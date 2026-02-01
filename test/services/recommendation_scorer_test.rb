require "test_helper"

class RecommendationScorerTest < ActiveSupport::TestCase
  # Disable fixtures since we create mock activities manually
  self.use_instantiated_fixtures = false
  self.fixture_table_names = []

  def setup
    @home_lat = 36.0
    @home_lng = -78.9
    @weather_normal = :normal
    @weather_deprioritize = :deprioritize_outdoor
  end

  # Helper to create a mock activity
  def create_activity(id, distance, activity_type, indoor)
    activity = Activity.new(
      id: id,
      name: "Test Activity #{id}",
      activity_type: activity_type,
      indoor: indoor,
      address: "123 Test St",
      latitude: @home_lat + (distance / 69.0), # Approximate miles to degrees
      longitude: @home_lng
    )
    activity.distance = distance
    activity
  end

  test "scores closer activities higher" do
    activity_close = create_activity(1, 2.0, 'playground', false)
    activity_far = create_activity(2, 10.0, 'playground', false)

    score_close = RecommendationScorer.score(activity_close, {}, @home_lat, @home_lng, @weather_normal)
    score_far = RecommendationScorer.score(activity_far, {}, @home_lat, @home_lng, @weather_normal)

    assert score_close > score_far, "Closer activity should score higher"
  end

  test "applies thumbs up boost" do
    activity = create_activity(1, 5.0, 'library', true)

    interactions_with_rating = {
      "1" => { 'rating' => 1, 'completions' => [], 'lastCompleted' => nil }
    }

    score_with_rating = RecommendationScorer.score(
      activity,
      interactions_with_rating,
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_without_rating = RecommendationScorer.score(
      activity,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert score_with_rating > score_without_rating, "Thumbs up should boost score"
    assert_in_delta 5.0, score_with_rating - score_without_rating, 0.01
  end

  test "applies thumbs down penalty" do
    activity = create_activity(1, 5.0, 'library', true)

    interactions_with_rating = {
      "1" => { 'rating' => -1, 'completions' => [], 'lastCompleted' => nil }
    }

    score_with_rating = RecommendationScorer.score(
      activity,
      interactions_with_rating,
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_without_rating = RecommendationScorer.score(
      activity,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert score_with_rating < score_without_rating, "Thumbs down should penalize score"
    assert_in_delta -5.0, score_with_rating - score_without_rating, 0.01
  end

  test "filters out activities completed in last 7 days" do
    activity_recent = create_activity(1, 3.0, 'museum', true)
    activity_old = create_activity(2, 4.0, 'library', true)

    interactions = {
      "1" => {
        'rating' => nil,
        'completions' => [(Time.current - 3.days).iso8601],
        'lastCompleted' => (Time.current - 3.days).iso8601
      }
    }

    sorted = RecommendationScorer.sort_with_scores(
      [activity_recent, activity_old],
      interactions,
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert_equal 1, sorted.length, "Should have one activity"
    assert_equal activity_old, sorted.first, "Should only show the non-recently-completed activity"
  end

  test "applies soft penalty for activities completed 8-21 days ago" do
    activity = create_activity(1, 3.0, 'museum', true)

    interactions_recent = {
      "1" => {
        'rating' => nil,
        'completions' => [(Time.current - 10.days).iso8601],
        'lastCompleted' => (Time.current - 10.days).iso8601
      }
    }

    score_with_penalty = RecommendationScorer.score(
      activity,
      interactions_recent,
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_without_penalty = RecommendationScorer.score(
      activity,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert score_with_penalty < score_without_penalty, "Recent completion should penalize score"
    assert_in_delta -3.0, score_with_penalty - score_without_penalty, 0.01
  end

  test "no penalty for activities completed more than 21 days ago" do
    activity = create_activity(1, 3.0, 'museum', true)

    interactions_old = {
      "1" => {
        'rating' => nil,
        'completions' => [(Time.current - 30.days).iso8601],
        'lastCompleted' => (Time.current - 30.days).iso8601
      }
    }

    score_with_old = RecommendationScorer.score(
      activity,
      interactions_old,
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_without = RecommendationScorer.score(
      activity,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert_in_delta 0, score_with_old - score_without, 0.01, "Old completion should have no penalty"
  end

  test "applies variety penalty to consecutive same types" do
    playground1 = create_activity(1, 2.0, 'playground', false)
    playground2 = create_activity(2, 2.1, 'playground', false)
    library = create_activity(3, 2.2, 'library', true)
    playground3 = create_activity(4, 2.3, 'playground', false)

    activities = [playground1, playground2, library, playground3]
    sorted = RecommendationScorer.sort_with_scores(
      activities,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    # Library should be promoted despite being slightly farther
    sorted_types = sorted.map(&:activity_type)

    # First should be playground (closest)
    assert_equal 'playground', sorted_types[0]

    # Second should ideally be library (different type) or playground2 if distance dominates
    # The exact order depends on weights, but we should see some variety
    refute_equal ['playground', 'playground', 'playground', 'library'], sorted_types,
                 "Variety penalty should prevent all playgrounds from appearing consecutively"
  end

  test "applies weather penalty to outdoor activities" do
    outdoor = create_activity(1, 5.0, 'playground', false)
    indoor = create_activity(2, 5.0, 'library', true)

    score_outdoor_deprioritize = RecommendationScorer.score(
      outdoor,
      {},
      @home_lat,
      @home_lng,
      @weather_deprioritize
    )
    score_outdoor_normal = RecommendationScorer.score(
      outdoor,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_indoor_deprioritize = RecommendationScorer.score(
      indoor,
      {},
      @home_lat,
      @home_lng,
      @weather_deprioritize
    )

    # Outdoor should be penalized when weather is deprioritize_outdoor
    assert score_outdoor_deprioritize < score_outdoor_normal,
           "Outdoor activity should score lower with deprioritize_outdoor weather"

    # Indoor should not be affected by weather
    score_indoor_normal = RecommendationScorer.score(
      indoor,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )
    assert_in_delta 0, score_indoor_deprioritize - score_indoor_normal, 0.01,
                    "Indoor activity should not be affected by weather"
  end

  test "combines multiple scoring factors correctly" do
    # Activity with thumbs up (5 mi away)
    activity_rated = create_activity(1, 5.0, 'library', true)
    interactions_rated = {
      "1" => { 'rating' => 1, 'completions' => [], 'lastCompleted' => nil }
    }

    # Activity without rating (1 mi away)
    activity_close = create_activity(2, 1.0, 'library', true)

    score_rated = RecommendationScorer.score(
      activity_rated,
      interactions_rated,
      @home_lat,
      @home_lng,
      @weather_normal
    )
    score_close = RecommendationScorer.score(
      activity_close,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    # Rated activity at 5 mi with +5 boost should score same as unrated at 1 mi
    # score_rated = -5 (distance) + 5 (rating) = 0
    # score_close = -1 (distance) = -1
    # So score_rated should actually be higher
    assert score_rated > score_close,
           "Rating boost should overcome distance penalty"
  end

  test "days_since_completion calculates correctly" do
    timestamp_3_days_ago = (Time.current - 3.days).iso8601
    days = RecommendationScorer.days_since_completion(timestamp_3_days_ago)

    assert_in_delta 3.0, days, 0.1, "Should calculate days correctly"
  end

  test "days_since_completion returns infinity for nil" do
    days = RecommendationScorer.days_since_completion(nil)
    assert_equal Float::INFINITY, days, "Should return infinity for nil"
  end

  test "days_since_completion handles invalid timestamps" do
    days = RecommendationScorer.days_since_completion("invalid timestamp")
    assert_equal Float::INFINITY, days, "Should return infinity for invalid timestamp"
  end

  test "relaxes filter when all activities are recently completed" do
    activity1 = create_activity(1, 2.0, 'playground', false)
    activity2 = create_activity(2, 3.0, 'library', true)

    # Both completed in last 7 days
    interactions = {
      "1" => {
        'rating' => nil,
        'completions' => [(Time.current - 3.days).iso8601],
        'lastCompleted' => (Time.current - 3.days).iso8601
      },
      "2" => {
        'rating' => nil,
        'completions' => [(Time.current - 5.days).iso8601],
        'lastCompleted' => (Time.current - 5.days).iso8601
      }
    }

    sorted = RecommendationScorer.sort_with_scores(
      [activity1, activity2],
      interactions,
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert_equal 2, sorted.length, "Should show all activities when all are recently completed"
  end

  test "skips variety penalty when one type dominates" do
    # Create 8 playgrounds and 2 libraries (80% playgrounds - above 70% threshold)
    activities = []
    8.times do |i|
      activities << create_activity(i + 1, 2.0 + (i * 0.1), 'playground', false)
    end
    2.times do |i|
      activities << create_activity(9 + i, 2.5 + (i * 0.1), 'library', true)
    end

    sorted = RecommendationScorer.sort_with_scores(
      activities,
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    # When one type dominates, variety penalty should not be applied
    # So activities should be sorted purely by distance
    assert_equal activities.sort_by(&:distance), sorted,
                 "Should not apply variety penalty when one type dominates"
  end

  test "sorts by distance when no interactions exist" do
    activity1 = create_activity(1, 5.0, 'playground', false)
    activity2 = create_activity(2, 2.0, 'library', true)
    activity3 = create_activity(3, 8.0, 'museum', true)

    sorted = RecommendationScorer.sort_with_scores(
      [activity1, activity2, activity3],
      {},
      @home_lat,
      @home_lng,
      @weather_normal
    )

    assert_equal [activity2, activity1, activity3], sorted,
                 "Should sort by distance when no interactions"
  end
end
