class EventImporter
  # Import a single event into the database
  # Returns { success: true/false, activity: Activity, errors: [] }
  def self.import(event_data, source_url)
    # Validate required fields
    unless event_data[:name].present? && event_data[:start_date].present?
      return {
        success: false,
        errors: ["Missing required fields: name or start_date"]
      }
    end

    # Find or initialize activity (handles duplicates)
    activity = find_or_initialize_activity(event_data, source_url)

    # Update attributes
    activity.assign_attributes(
      name: event_data[:name],
      description: event_data[:description],
      start_date: event_data[:start_date],
      end_date: event_data[:end_date] || (event_data[:start_date] + 2.hours),
      address: event_data[:address],
      website: source_url,
      registration_url: event_data[:registration_url],
      cost_level: event_data[:cost_level] || 0,
      activity_type: map_category_to_type(event_data[:categories]),
      is_event: true,
      indoor: infer_indoor(event_data),
      source_url: source_url,
      last_synced_at: Time.current
    )

    # Geocode if address changed
    if activity.address_changed? && activity.address.present?
      geocode_activity(activity)
    end

    # Validate and save
    if activity.valid?
      activity.save!
      {
        success: true,
        activity: activity,
        created: activity.id_previously_changed?
      }
    else
      {
        success: false,
        errors: activity.errors.full_messages
      }
    end
  rescue => e
    Rails.logger.error("Event import error: #{e.message}")
    {
      success: false,
      errors: [e.message]
    }
  end

  private

  # Three-tier duplicate detection:
  # 1. Match by source_url (exact)
  # 2. Match by name + start_date (fuzzy, ±1 day)
  # 3. Create new
  def self.find_or_initialize_activity(event_data, source_url)
    # Strategy 1: Match by source_url (most reliable)
    existing = Activity.find_by(source_url: source_url)
    return existing if existing

    # Strategy 2: Match by name + start_date (within 1 day)
    # Handles case where URL changes but event is same
    if event_data[:name].present? && event_data[:start_date].present?
      existing = Activity.where(
        name: event_data[:name],
        start_date: (event_data[:start_date] - 1.day)..(event_data[:start_date] + 1.day)
      ).first

      return existing if existing
    end

    # Strategy 3: Create new activity
    Activity.new
  end

  # Map RSS categories to activity_type enum
  # Categories from RSS: Holiday, Kids, Festival, Sports, Museum, Library, etc.
  def self.map_category_to_type(categories)
    return 'event' if categories.blank?

    categories_str = categories.join(' ').downcase

    # Check for specific activity types
    return 'library' if categories_str.match?(/library/)
    return 'museum' if categories_str.match?(/museum/)
    return 'splash_pad' if categories_str.match?(/splash|water/)
    return 'farm' if categories_str.match?(/farm/)
    return 'park' if categories_str.match?(/park/) && !categories_str.match?(/playground/)
    return 'playground' if categories_str.match?(/playground/)

    # Default for most RSS events
    'event'
  end

  # Infer indoor/outdoor from content
  # Keywords guide the decision
  def self.infer_indoor(event_data)
    text = "#{event_data[:name]} #{event_data[:description]} #{event_data[:categories]&.join(' ')}".downcase

    # Definite indoor keywords
    return true if text.match?(/indoor|museum|library|mall|center|theatre|theater|aquarium/i)

    # Definite outdoor keywords
    return false if text.match?(/outdoor|park|playground|garden|trail|farm|beach|pool/i)

    # Check address for indoor venues
    if event_data[:address].present?
      return true if event_data[:address].downcase.match?(/library|museum|center|mall/)
    end

    # Default: outdoor for kid events (playgrounds, parks, etc. are common)
    false
  end

  # Geocode address to get lat/lng coordinates
  # Uses existing Geocoder gem
  def self.geocode_activity(activity)
    return unless activity.address.present?

    results = Geocoder.search(activity.address)
    if results.first
      activity.latitude = results.first.latitude
      activity.longitude = results.first.longitude
      Rails.logger.info("Geocoded #{activity.name} to #{activity.latitude}, #{activity.longitude}")
    else
      Rails.logger.warn("Geocoding failed for: #{activity.address}")
    end
  rescue => e
    Rails.logger.error("Geocoding error for #{activity.name}: #{e.message}")
    # Continue without coordinates - don't block import
  end
end
