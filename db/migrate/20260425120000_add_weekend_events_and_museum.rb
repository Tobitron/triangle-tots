class AddWeekendEventsAndMuseum < ActiveRecord::Migration[8.1]
  def up
    # Remove Read to Me Pet Partners (Durham library reading-with-dogs event)
    Activity.where(source_url: "https://thetrianglemom.com/events/read-to-me-pet-partners-dcl-15466545").destroy_all

    # Piedmont Farm Tour 2026
    unless Activity.exists?(name: "2026 Piedmont Farm Tour")
      Activity.create!(
        name: "2026 Piedmont Farm Tour",
        activity_type: "farm",
        address: "Multiple farms across Orange, Durham & Chatham Counties, NC",
        cost_level: 2,
        description: "An annual self-guided tour of 30 working farms open for one weekend only. Several farms within 30 minutes of Chapel Hill are exceptional for toddlers: Boxcarr Farms (Cedar Grove) has baby goats in kidding season and opens at noon; Chapel Hill Creamery lets kids meet spring calves and taste cheese; Jireh Family Farm (Durham) has cattle, chickens, hogs, and serves ice cream on-site. $35/carload pass grants access to all farms. Rain or shine.",
        start_date: Time.zone.parse("2026-04-25 12:00:00"),
        end_date: Time.zone.parse("2026-04-26 18:00:00"),
        indoor: false,
        is_event: true,
        hours: {},
        website: "https://carolinafarmstewards.org/piedmont-farm-tour/",
        source_url: "https://carolinafarmstewards.org/piedmont-farm-tour/"
      )
    end

    # U-Pick Strawberries at Chatham Oaks Farm
    unless Activity.exists?(name: "U-Pick Strawberries at Chatham Oaks Farm")
      Activity.create!(
        name: "U-Pick Strawberries at Chatham Oaks Farm",
        activity_type: "farm",
        address: "573 Dewitt Smith Rd, Pittsboro, NC 27312",
        cost_level: 1,
        description: "Late April marks the start of strawberry season at Chatham Oaks Farm — a seasonal window that lasts only a few weeks. Kids can pick their own strawberries right from the field. The farm is also participating in the Piedmont Farm Tour this weekend, with food trucks on-site both days. Call ahead to confirm berry availability before visiting: 919-533-7621. Weekend hours 1–6 PM.",
        start_date: Time.zone.parse("2026-04-25 13:00:00"),
        end_date: Time.zone.parse("2026-04-26 18:00:00"),
        indoor: false,
        is_event: true,
        hours: {},
        latitude: 35.7173,
        longitude: -79.1669,
        website: "https://www.chathamoaksfarm.com/strawberries",
        source_url: "https://www.chathamoaksfarm.com/strawberries"
      )
    end

    # Museum of Life and Science (evergreen)
    unless Activity.exists?(name: "Museum of Life and Science")
      Activity.create!(
        name: "Museum of Life and Science",
        activity_type: "museum",
        address: "433 W. Murray Avenue, Durham, NC 27704",
        cost_level: 2,
        description: "One of the Triangle's best destinations for toddlers. Sprawling indoor/outdoor museum with a butterfly house, dinosaur trail, farm animals, a train ride, and hands-on science exhibits. Kids under 2 are free. Members get in at 9am; general admission opens at 10am.",
        indoor: false,
        is_event: false,
        hours: {
          monday: "closed",
          tuesday: "10:00 AM - 5:00 PM",
          wednesday: "10:00 AM - 5:00 PM",
          thursday: "10:00 AM - 5:00 PM",
          friday: "10:00 AM - 5:00 PM",
          saturday: "10:00 AM - 5:00 PM",
          sunday: "10:00 AM - 5:00 PM"
        },
        latitude: 36.0132,
        longitude: -78.9071,
        website: "https://www.lifeandscience.org",
        source_url: "https://www.lifeandscience.org"
      )
    end
  end

  def down
    Activity.where(name: "2026 Piedmont Farm Tour").destroy_all
    Activity.where(name: "U-Pick Strawberries at Chatham Oaks Farm").destroy_all
    Activity.where(name: "Museum of Life and Science").destroy_all
  end
end
