# Triangle Tots - Seed Data
# Initial evergreen activities for 3-year-olds in the Triangle area

puts "Seeding activities..."

# Clear existing data
Activity.destroy_all

# Playgrounds
Activity.create!([
  {
    name: "Homestead Park Playground",
    description: "Large playground with slides, swings, and climbing structures. Shaded picnic areas available. Great for toddlers with separate play area for younger kids.",
    address: "200 Homestead Rd, Chapel Hill, NC 27516",
    latitude: 35.9132,
    longitude: -79.0558,
    activity_type: "playground",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "dawn - dusk",
      tuesday: "dawn - dusk",
      wednesday: "dawn - dusk",
      thursday: "dawn - dusk",
      friday: "dawn - dusk",
      saturday: "dawn - dusk",
      sunday: "dawn - dusk"
    },
    website: "https://www.townofchapelhill.org/government/departments-services/parks-recreation"
  },
  {
    name: "Pigeon House Branch Park",
    description: "Playground with swings, slides, and a small splash pad area. Basketball courts and walking trails nearby.",
    address: "500 Pigeon House Rd, Chapel Hill, NC 27516",
    latitude: 35.9421,
    longitude: -79.0389,
    activity_type: "playground",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "dawn - dusk",
      tuesday: "dawn - dusk",
      wednesday: "dawn - dusk",
      thursday: "dawn - dusk",
      friday: "dawn - dusk",
      saturday: "dawn - dusk",
      sunday: "dawn - dusk"
    }
  }
])

# Libraries
Activity.create!([
  {
    name: "Chapel Hill Public Library - Story Time",
    description: "Weekly story time for preschoolers. Songs, stories, and activities. Free and no registration required.",
    address: "100 Library Dr, Chapel Hill, NC 27514",
    latitude: 35.9270,
    longitude: -79.0464,
    activity_type: "library",
    indoor: true,
    cost_level: 0,
    hours: {
      monday: "10:00 AM - 6:00 PM",
      tuesday: "10:00 AM - 9:00 PM",
      wednesday: "10:00 AM - 9:00 PM",
      thursday: "10:00 AM - 6:00 PM",
      friday: "10:00 AM - 6:00 PM",
      saturday: "10:00 AM - 6:00 PM",
      sunday: "1:00 PM - 5:00 PM"
    },
    website: "https://chapelhillpubliclibrary.org",
    phone: "(919) 968-2777"
  },
  {
    name: "Durham County Library - Main",
    description: "Large children's section with play area. Regular story times and activities for toddlers and preschoolers.",
    address: "300 N Roxboro St, Durham, NC 27701",
    latitude: 36.0014,
    longitude: -78.9015,
    activity_type: "library",
    indoor: true,
    cost_level: 0,
    hours: {
      monday: "10:00 AM - 9:00 PM",
      tuesday: "10:00 AM - 9:00 PM",
      wednesday: "10:00 AM - 9:00 PM",
      thursday: "10:00 AM - 9:00 PM",
      friday: "10:00 AM - 6:00 PM",
      saturday: "10:00 AM - 6:00 PM",
      sunday: "1:00 PM - 6:00 PM"
    },
    website: "https://www.durhamcountylibrary.org",
    phone: "(919) 560-0100"
  }
])

# Museums
Activity.create!([
  {
    name: "Museum of Life and Science",
    description: "Interactive science museum with dinosaurs, trains, butterflies, and outdoor nature park. Magic Wings Butterfly House is a favorite for toddlers.",
    address: "433 W Murray Ave, Durham, NC 27704",
    latitude: 36.0197,
    longitude: -78.9136,
    activity_type: "museum",
    indoor: false,
    cost_level: 2,
    hours: {
      monday: "10:00 AM - 5:00 PM",
      tuesday: "10:00 AM - 5:00 PM",
      wednesday: "10:00 AM - 5:00 PM",
      thursday: "10:00 AM - 5:00 PM",
      friday: "10:00 AM - 5:00 PM",
      saturday: "10:00 AM - 5:00 PM",
      sunday: "12:00 PM - 5:00 PM"
    },
    website: "https://www.lifeandscience.org",
    phone: "(919) 220-5429"
  },
  {
    name: "Kidzu Children's Museum",
    description: "Hands-on children's museum designed for kids 0-10. Interactive exhibits, pretend play areas, and toddler-friendly activities.",
    address: "105 E Franklin St, Chapel Hill, NC 27514",
    latitude: 35.9132,
    longitude: -79.0558,
    activity_type: "museum",
    indoor: true,
    cost_level: 1,
    hours: {
      monday: "closed",
      tuesday: "9:00 AM - 5:00 PM",
      wednesday: "9:00 AM - 5:00 PM",
      thursday: "9:00 AM - 5:00 PM",
      friday: "9:00 AM - 5:00 PM",
      saturday: "9:00 AM - 5:00 PM",
      sunday: "1:00 PM - 5:00 PM"
    },
    website: "https://www.kidzuchildrensmuseum.org",
    phone: "(919) 933-1455"
  }
])

# Parks
Activity.create!([
  {
    name: "Duke Gardens",
    description: "Beautiful botanical gardens with wide paved paths perfect for strollers. Doris Duke Center has interactive exhibits for kids.",
    address: "420 Anderson St, Durham, NC 27708",
    latitude: 36.0041,
    longitude: -78.9382,
    activity_type: "park",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "8:00 AM - 8:00 PM",
      tuesday: "8:00 AM - 8:00 PM",
      wednesday: "8:00 AM - 8:00 PM",
      thursday: "8:00 AM - 8:00 PM",
      friday: "8:00 AM - 8:00 PM",
      saturday: "8:00 AM - 8:00 PM",
      sunday: "8:00 AM - 8:00 PM"
    },
    website: "https://gardens.duke.edu"
  },
  {
    name: "Lake Johnson Park",
    description: "Large park with playground, walking trails around the lake, and picnic areas. Easy trails suitable for toddlers.",
    address: "4601 Avent Ferry Rd, Raleigh, NC 27606",
    latitude: 35.7596,
    longitude: -78.6869,
    activity_type: "park",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "dawn - dusk",
      tuesday: "dawn - dusk",
      wednesday: "dawn - dusk",
      thursday: "dawn - dusk",
      friday: "dawn - dusk",
      saturday: "dawn - dusk",
      sunday: "dawn - dusk"
    },
    website: "https://www.raleighnc.gov/parks/lake-johnson"
  }
])

# Indoor Play
Activity.create!([
  {
    name: "Marbles Kids Museum",
    description: "Three floors of hands-on exhibits for children. Toddler area with soft play structures and age-appropriate activities.",
    address: "201 E Hargett St, Raleigh, NC 27601",
    latitude: 35.7796,
    longitude: -78.6382,
    activity_type: "indoor_play",
    indoor: true,
    cost_level: 2,
    hours: {
      monday: "closed",
      tuesday: "9:00 AM - 5:00 PM",
      wednesday: "9:00 AM - 5:00 PM",
      thursday: "9:00 AM - 5:00 PM",
      friday: "9:00 AM - 5:00 PM",
      saturday: "9:00 AM - 5:00 PM",
      sunday: "12:00 PM - 5:00 PM"
    },
    website: "https://www.marbleskidsmuseum.org",
    phone: "(919) 857-4HO"
  }
])

# Farms
Activity.create!([
  {
    name: "Maple View Farm",
    description: "Working dairy farm with ice cream shop. See cows, calves, and farm animals. Large lawn area for kids to run around.",
    address: "3514 Dairyland Rd, Hillsborough, NC 27278",
    latitude: 36.0132,
    longitude: -79.1558,
    activity_type: "farm",
    indoor: false,
    cost_level: 1,
    hours: {
      monday: "11:00 AM - 9:00 PM",
      tuesday: "11:00 AM - 9:00 PM",
      wednesday: "11:00 AM - 9:00 PM",
      thursday: "11:00 AM - 9:00 PM",
      friday: "11:00 AM - 10:00 PM",
      saturday: "11:00 AM - 10:00 PM",
      sunday: "12:00 PM - 9:00 PM"
    },
    website: "https://www.mapleviewfarm.com",
    phone: "(919) 960-5535"
  }
])

puts "Created #{Activity.count} activities!"
puts "Activity types: #{Activity.group(:activity_type).count}"
