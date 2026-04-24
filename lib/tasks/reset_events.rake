namespace :events do
  desc "Delete all upcoming events, clear caches, and re-sync with quality filter"
  task reset: :environment do
    deleted = Activity.where(is_event: true).where("start_date > ?", Time.current).destroy_all
    puts "Deleted #{deleted.count} upcoming events"

    %w[triangle_rss_feed rss_age_filter_top5 triangle_mom_events triangle_mom_top5 tavily_event_search].each do |key|
      Rails.cache.delete(key)
    end
    puts "Caches cleared"

    SyncEventsJob.new.perform
    puts "Sync complete"

    puts "\nSurviving events:"
    Activity.where(is_event: true).where("start_date > ?", Time.current).order(:start_date).each do |a|
      puts "  #{a.start_date.strftime("%a %b %-d")} | #{a.name}"
    end
    puts "\nTotal: #{Activity.where(is_event: true).where("start_date > ?", Time.current).count}"
  end
end
