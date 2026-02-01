# Scores and sorts activities based on multiple factors:
# - Distance from home
# - User ratings (thumbs up/down)
# - Recency of completion
# - Variety (prevent consecutive same-type activities)
# - Weather conditions
class RecommendationScorer
  # Configurable weights for scoring factors
  WEIGHTS = {
    distance: 1.0,           # Base weight for distance (1 point per mile)
    rating: 5.0,             # Significant boost for thumbs up
    recency_hide: -1000,     # Complete exclusion for recent completions
    recency_penalty: -3.0,   # Moderate penalty for deprioritization period
    variety_penalty: -2.0,   # Penalty for consecutive same-type activities
    weather_penalty: -4.0    # Weather-based deprioritization
  }.freeze

  RECENCY_HIDE_DAYS = 7
  RECENCY_PENALTY_DAYS = 21  # Total period (includes the 7-day hide)
  VARIETY_WINDOW_SIZE = 3    # Look at top N results for variety
  TYPE_DOMINANCE_THRESHOLD = 0.7  # 70% threshold to disable variety penalty

  # Main scoring method
  # @param activity [Activity] - activity to score
  # @param interactions [Hash] - user interactions from localStorage
  # @param home_lat [Float] - user's latitude
  # @param home_lng [Float] - user's longitude
  # @param weather_strategy [Symbol] - :hide_outdoor, :deprioritize_outdoor, :normal
  # @param position_in_results [Integer] - current position (for variety penalty)
  # @param previous_types [Array<String>] - activity types in previous positions
  # @return [Float] - composite score (higher is better)
  def self.score(activity, interactions, home_lat, home_lng, weather_strategy, position_in_results = 0, previous_types = [])
    score = 0.0

    # 1. Distance Score (inverted: closer is better)
    # Convert distance to a score where 0 miles = 0 penalty, 20+ miles = -20
    distance = activity.distance || 20
    score -= (distance * WEIGHTS[:distance])

    # 2. Rating Score
    interaction = interactions[activity.id.to_s]
    if interaction && interaction['rating']
      if interaction['rating'] == 1  # Thumbs up
        score += WEIGHTS[:rating]
      elsif interaction['rating'] == -1  # Thumbs down
        score -= WEIGHTS[:rating]
      end
    end

    # 3. Recency Score
    if interaction && interaction['lastCompleted']
      days_since = days_since_completion(interaction['lastCompleted'])

      if days_since < RECENCY_HIDE_DAYS
        # Hard filter: will be removed before scoring in practice
        score += WEIGHTS[:recency_hide]
      elsif days_since < RECENCY_PENALTY_DAYS
        # Deprioritize: moderate penalty
        score += WEIGHTS[:recency_penalty]
      end
    end

    # 4. Variety Score
    # Penalize if same activity type appears in previous N positions
    if position_in_results > 0 && previous_types.include?(activity.activity_type)
      score += WEIGHTS[:variety_penalty]
    end

    # 5. Weather Score
    if weather_strategy == :deprioritize_outdoor && !activity.indoor
      score += WEIGHTS[:weather_penalty]
    end

    score
  end

  # Calculate days since last completion
  # @param last_completed_timestamp [String] - ISO 8601 timestamp
  # @return [Float] - days since completion, or Infinity if nil
  def self.days_since_completion(last_completed_timestamp)
    return Float::INFINITY if last_completed_timestamp.nil?

    begin
      last_completed = Time.parse(last_completed_timestamp)
      ((Time.current - last_completed) / 1.day).to_f
    rescue ArgumentError
      # Invalid timestamp format
      Float::INFINITY
    end
  end

  # Sort activities with scoring
  # Returns activities sorted by composite score with variety penalty applied
  # @param activities [Array<Activity>] - activities to sort
  # @param interactions [Hash] - user interactions from localStorage
  # @param home_lat [Float] - user's latitude
  # @param home_lng [Float] - user's longitude
  # @param weather_strategy [Symbol] - :hide_outdoor, :deprioritize_outdoor, :normal
  # @return [Array<Activity>] - sorted activities
  def self.sort_with_scores(activities, interactions, home_lat, home_lng, weather_strategy)
    # First pass: filter out hard-hidden activities (completed in last 7 days)
    filtered = filter_recently_completed(activities, interactions)

    # If all activities were filtered out, relax the filter
    if filtered.empty? && activities.any?
      # Show them anyway with no recency filtering
      filtered = activities
    end

    # Second pass: score all activities
    scored_activities = filtered.map do |activity|
      score = score(activity, interactions, home_lat, home_lng, weather_strategy)
      { activity: activity, score: score }
    end

    # Sort by score (descending)
    scored_activities.sort_by! { |item| -item[:score] }

    # Third pass: apply variety penalty if needed
    if should_apply_variety_penalty?(scored_activities)
      apply_variety_penalty!(scored_activities, interactions, home_lat, home_lng, weather_strategy)
    end

    # Return just the activities
    scored_activities.map { |item| item[:activity] }
  end

  private

  # Filter out activities completed in the last 7 days
  # @param activities [Array<Activity>] - activities to filter
  # @param interactions [Hash] - user interactions
  # @return [Array<Activity>] - filtered activities
  def self.filter_recently_completed(activities, interactions)
    activities.reject do |activity|
      interaction = interactions[activity.id.to_s]
      if interaction && interaction['lastCompleted']
        days_since_completion(interaction['lastCompleted']) < RECENCY_HIDE_DAYS
      else
        false
      end
    end
  end

  # Determine if variety penalty should be applied
  # Don't apply if a single type dominates (>70% of results)
  # @param scored_activities [Array<Hash>] - scored activities
  # @return [Boolean] - true if variety penalty should be applied
  def self.should_apply_variety_penalty?(scored_activities)
    return false if scored_activities.length < 3

    # Count activity types
    type_counts = Hash.new(0)
    scored_activities.each do |item|
      type_counts[item[:activity].activity_type] += 1
    end

    # Check if any type dominates (>70%)
    max_count = type_counts.values.max
    dominance_ratio = max_count.to_f / scored_activities.length

    # Don't apply variety penalty if one type dominates
    dominance_ratio < TYPE_DOMINANCE_THRESHOLD
  end

  # Apply variety penalty and re-sort
  # Modifies the scored_activities array in place
  # @param scored_activities [Array<Hash>] - scored activities
  # @param interactions [Hash] - user interactions
  # @param home_lat [Float] - user's latitude
  # @param home_lng [Float] - user's longitude
  # @param weather_strategy [Symbol] - weather strategy
  def self.apply_variety_penalty!(scored_activities, interactions, home_lat, home_lng, weather_strategy)
    previous_types = []

    # Re-score first N items with variety context
    scored_activities.take(VARIETY_WINDOW_SIZE * 2).each_with_index do |item, index|
      # Re-calculate score with variety context
      item[:score] = score(
        item[:activity],
        interactions,
        home_lat,
        home_lng,
        weather_strategy,
        index,
        previous_types
      )
      previous_types << item[:activity].activity_type
    end

    # Re-sort with variety penalty applied
    scored_activities.sort_by! { |item| -item[:score] }
  end
end
