class EventQualityFilter
  PROMPT = <<~PROMPT
    You are a strict quality filter for a family app that shows weekend activities for parents with a 2–4 year old toddler in the Chapel Hill / Durham / Carrboro / Cary / Hillsborough area of North Carolina.

    For each event below, decide whether it PASSES or FAILS.

    An event PASSES only if ALL of the following are true:
    - A 2-year-old can actively participate (not just observe adults perform). Well-known family event formats — storytime, touch-a-truck, open farm play, railroad days, science festivals with hands-on stations, art carts — count as active participation without needing explicit description.
    - Located in Chapel Hill, Durham, Carrboro, Cary, or Hillsborough (not Raleigh, Apex, Wake Forest, or other outlying cities)
    - Cost is $15 or under per person
    - The event is NOT a festival, fair, carnival, or multi-vendor gathering
    - The event is NOT at a brewery, winery, or adult venue
    - The event is appropriate for children age 2-4 (family events and children's events both qualify — it does not need to be exclusively for ages 2-4)

    An event FAILS only if it clearly violates one of the above rules. Vague descriptions are NOT sufficient reason to fail an event if the event name or type makes it obviously appropriate (e.g. "Storytime", "Touch-a-Truck", "Open Farm Play"). Only fail for vagueness if you genuinely cannot tell whether a 2-year-old can participate.

    Additionally, an event FAILS if the description explicitly states an age or grade requirement that excludes 2-year-olds — for example "grades K-8", "ages 5+", "ages 6 and up", "for school-age children", etc.

    Respond ONLY with a JSON object mapping each event ID to "pass" or "fail":
    {"1": "pass", "2": "fail", ...}

    Events:
    [EVENT LIST]
  PROMPT

  COST_LABELS = [ "Free", "$1-5", "$6-15", "$16+" ].freeze
  AUDIT_DIR   = Rails.root.join("storage", "event_sync_audits")
  ALLOWLIST_PATH = Rails.root.join("config", "event_quality_allowlist.yml")

  def self.filter(activities)
    return 0 if activities.empty?

    allowlist = load_allowlist
    approved, to_review = activities.partition { |a| allowlist.include?(a.source_url.to_s) }

    verdicts = {}
    removed  = []

    if to_review.any?
      client = Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"))
      response = client.messages.create(
        model:      "claude-sonnet-4-6",
        max_tokens: 1024,
        messages:   [ { role: "user", content: build_prompt(to_review) } ]
      )

      text = response.content.find { |b| b.type == :text }&.text.to_s.strip
      verdicts = JSON.parse(extract_json(text))

      failed_ids = verdicts.filter_map { |id, verdict| id.to_i if verdict == "fail" }
      removed = Activity.where(id: failed_ids).destroy_all
    end

    passed = to_review.reject { |a| removed.map(&:id).include?(a.id) }

    Rails.logger.info("EventQualityFilter: #{removed.count}/#{activities.count} events removed (#{passed.count} passed, #{approved.count} allowlisted)")
    removed.each { |a| Rails.logger.info("  Removed: #{a.name} (#{a.source_url})") }

    write_audit(approved, passed, removed)

    removed.count
  rescue => e
    Rails.logger.error("EventQualityFilter failed: #{e.message}")
    0
  end

  private

  def self.load_allowlist
    return [] unless ALLOWLIST_PATH.exist?
    urls = YAML.load_file(ALLOWLIST_PATH)
    Array(urls).map(&:strip).to_set
  rescue => e
    Rails.logger.error("EventQualityFilter: failed to load allowlist — #{e.message}")
    []
  end

  def self.write_audit(approved, passed, removed)
    FileUtils.mkdir_p(AUDIT_DIR)
    filename = AUDIT_DIR.join("#{Time.current.strftime("%Y-%m-%d_%H%M%S")}.txt")

    lines = []
    lines << "Event Sync Quality Filter Audit"
    lines << "Run at: #{Time.current.strftime("%Y-%m-%d %H:%M:%S %Z")}"
    lines << "=" * 60
    lines << ""

    if approved.any?
      lines << "MANUALLY APPROVED — skipped filter (#{approved.count}):"
      approved.each { |a| lines << "  [approved] #{format_event(a)}" }
      lines << ""
    end

    lines << "PASSED FILTER (#{passed.count}):"
    if passed.any?
      passed.each { |a| lines << "  [pass] #{format_event(a)}" }
    else
      lines << "  (none)"
    end
    lines << ""

    lines << "REMOVED BY FILTER (#{removed.count}):"
    if removed.any?
      removed.each { |a| lines << "  [fail] #{format_event(a)}" }
    else
      lines << "  (none)"
    end

    File.write(filename, lines.join("\n") + "\n")
    Rails.logger.info("EventQualityFilter: audit written to #{filename}")
  rescue => e
    Rails.logger.error("EventQualityFilter: failed to write audit — #{e.message}")
  end

  def self.format_event(activity)
    date = activity.start_date&.strftime("%a %b %-d %-I:%M%p") || "unknown date"
    cost = COST_LABELS[activity.cost_level] || "unknown"
    "#{activity.name} | #{date} | #{activity.address.presence || "unknown"} | #{cost} | #{activity.source_url}"
  end

  def self.build_prompt(activities)
    event_list = activities.map do |activity|
      cost = COST_LABELS[activity.cost_level] || "unknown"
      date = activity.start_date&.strftime("%A %B %-d at %-I:%M %p") || "unknown"

      <<~EVENT
        ID: #{activity.id}
        Name: #{activity.name}
        Date: #{date}
        Address: #{activity.address.presence || "unknown"}
        Cost: #{cost}
        Description: #{activity.description.to_s.truncate(400)}
      EVENT
    end.join("\n")

    PROMPT.sub("[EVENT LIST]", event_list)
  end

  def self.extract_json(text)
    match = text.match(/\{.*\}/m)
    match ? match[0] : text
  end
end
