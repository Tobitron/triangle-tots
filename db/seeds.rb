# Triangle Tots - Seed Data
# Initial evergreen activities for 3-year-olds in the Triangle area

puts "Seeding activities..."

# Clear existing evergreen activities (preserve synced events)
Activity.where(is_event: false).destroy_all

# Playgrounds
Activity.create!([
  {
    name: "Southern Community Park",
    description: "Large park with a great playground, seasonal splash pad, open fields, and easy walking trails. Has a dedicated toddler play area and shade trees.",
    address: "1000 Barbee Rd, Chapel Hill, NC 27517",
    latitude: 35.8832,
    longitude: -79.0440,
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
    name: "Cedar Falls Park",
    description: "Nature-themed playground with creek access and wooded trails. Beloved local park with unique climbing structures and a peaceful natural setting.",
    address: "500 Cedar Falls Rd, Chapel Hill, NC 27516",
    latitude: 35.9019,
    longitude: -79.0291,
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
  },
  {
    name: "Pullen Park",
    description: "Raleigh's beloved classic park with a carousel, train ride, paddle boats, and toddler-friendly playground. The carousel and train are a huge hit for 3-year-olds. Small fee per ride.",
    address: "520 Ashe Ave, Raleigh, NC 27606",
    latitude: 35.7864,
    longitude: -78.6592,
    activity_type: "playground",
    indoor: false,
    cost_level: 1,
    hours: {
      monday: "dawn - dusk",
      tuesday: "dawn - dusk",
      wednesday: "dawn - dusk",
      thursday: "dawn - dusk",
      friday: "dawn - dusk",
      saturday: "dawn - dusk",
      sunday: "dawn - dusk"
    },
    website: "https://raleighnc.gov/parks/pullen-park"
  },
  {
    name: "Homestead Park Playground",
    description: "Known as \"Dinosaur Park\" for its iconic purple dinosaur slide. Dedicated toddler play area plus a full-size structure, rubber surface, and shaded picnic tables. A Chapel Hill playgroup staple. Note: restrooms closed October–May.",
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
    name: "Wilson Park",
    description: "Carrboro family favorite with new play equipment, a sandbox with diggers, climbing dome, swings, and slides. Baseball field, tennis courts, and Bolin Creek Greenway access nearby.",
    address: "110 Williams St, Carrboro, NC 27510",
    latitude: 35.9198,
    longitude: -79.0755,
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
    website: "https://townofcarrboro.org/370/Wilson-Park"
  },
  {
    name: "Chapel Hill Community Center Playground",
    description: "Fully rebuilt inclusive playground opened April 2025 with ADA ramps, inclusive spinners, sensory features, and toddler-friendly swings on a rubber surface. One of Chapel Hill's best. Parking can be tight on weekends.",
    address: "120 S Estes Dr, Chapel Hill, NC 27514",
    latitude: 35.9155,
    longitude: -79.0469,
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
    website: "https://www.chapelhillnc.gov/government/departments-services/parks-and-recreation"
  },
  {
    name: "Oakwood Park",
    description: "One of the few fenced playgrounds in Chapel Hill — great for toddlers who like to run. Shady, with 2024 inclusive equipment upgrades. Small neighborhood park; no restrooms and street parking only.",
    address: "20 Oakwood Dr, Chapel Hill, NC 27517",
    latitude: 35.8968,
    longitude: -79.0573,
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
    website: "https://www.chapelhillnc.gov/government/departments-services/parks-and-recreation"
  }
])

# Pools / Aquatics
Activity.create!([
  {
    name: "Homestead Aquatics Center",
    description: "Indoor and outdoor pools with a dedicated toddler wading pool and water play area. Swim lessons available for infants and toddlers. Zero-entry pool makes it easy for little ones.",
    address: "200 Homestead Rd, Chapel Hill, NC 27516",
    latitude: 35.9132,
    longitude: -79.0558,
    activity_type: "indoor_play",
    indoor: true,
    cost_level: 1,
    hours: {
      monday: "5:30 AM - 9:00 PM",
      tuesday: "5:30 AM - 9:00 PM",
      wednesday: "5:30 AM - 9:00 PM",
      thursday: "5:30 AM - 9:00 PM",
      friday: "5:30 AM - 8:00 PM",
      saturday: "8:00 AM - 6:00 PM",
      sunday: "12:00 PM - 5:00 PM"
    },
    website: "https://www.townofchapelhill.org/government/departments-services/parks-recreation/aquatics",
    phone: "(919) 968-2790"
  },
  {
    name: "Hargraves Community Center Pool",
    description: "Outdoor community pool open in summer months. Toddler pool area and swim lessons available.",
    address: "216 N Roberson St, Chapel Hill, NC 27516",
    latitude: 35.9190,
    longitude: -79.0509,
    activity_type: "indoor_play",
    indoor: false,
    cost_level: 1,
    hours: {
      monday: "closed",
      tuesday: "1:00 PM - 6:00 PM",
      wednesday: "1:00 PM - 6:00 PM",
      thursday: "1:00 PM - 6:00 PM",
      friday: "1:00 PM - 6:00 PM",
      saturday: "11:00 AM - 5:00 PM",
      sunday: "1:00 PM - 5:00 PM"
    },
    website: "https://www.townofchapelhill.org/government/departments-services/parks-recreation/aquatics",
    phone: "(919) 968-2790"
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

# Libraries (additional)
Activity.create!([
  {
    name: "Orange County Library - Hillsborough",
    description: "Branch library with regular toddler story times and a children's section.",
    address: "137 W Margaret Ln, Hillsborough, NC 27278",
    latitude: 36.0750,
    longitude: -79.0962,
    activity_type: "library",
    indoor: true,
    cost_level: 0,
    hours: {
      monday: "10:00 AM - 8:00 PM",
      tuesday: "10:00 AM - 8:00 PM",
      wednesday: "10:00 AM - 8:00 PM",
      thursday: "10:00 AM - 8:00 PM",
      friday: "10:00 AM - 6:00 PM",
      saturday: "10:00 AM - 6:00 PM",
      sunday: "closed"
    },
    website: "https://www.orangecountync.gov/library"
  }
])

# Museums
Activity.create!([
  {
    name: "NC Museum of Natural Sciences",
    description: "Free admission! Massive natural history museum with live animals, dinosaur fossils, a live butterfly lab, and the Nature Explore Gallery designed for kids. One of the best free things to do in the Triangle.",
    address: "11 W Jones St, Raleigh, NC 27601",
    latitude: 35.7812,
    longitude: -78.6385,
    activity_type: "museum",
    indoor: true,
    cost_level: 0,
    hours: {
      monday: "9:00 AM - 5:00 PM",
      tuesday: "9:00 AM - 5:00 PM",
      wednesday: "9:00 AM - 5:00 PM",
      thursday: "9:00 AM - 5:00 PM",
      friday: "9:00 AM - 5:00 PM",
      saturday: "9:00 AM - 5:00 PM",
      sunday: "12:00 PM - 5:00 PM"
    },
    website: "https://naturalsciences.org",
    phone: "(919) 707-9800"
  },
  {
    name: "Morehead Planetarium & Science Center",
    description: "UNC's planetarium offers family-friendly star shows and science exhibits. The star shows are magical for toddlers. Small admission fee.",
    address: "250 E Franklin St, Chapel Hill, NC 27514",
    latitude: 35.9147,
    longitude: -79.0519,
    activity_type: "museum",
    indoor: true,
    cost_level: 1,
    hours: {
      monday: "closed",
      tuesday: "10:00 AM - 3:30 PM",
      wednesday: "10:00 AM - 3:30 PM",
      thursday: "10:00 AM - 3:30 PM",
      friday: "10:00 AM - 3:30 PM",
      saturday: "10:00 AM - 4:30 PM",
      sunday: "1:00 PM - 4:30 PM"
    },
    website: "https://moreheadplanetarium.org",
    phone: "(919) 962-1236"
  },
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

# Parks & Nature
Activity.create!([
  {
    name: "Eno River State Park",
    description: "Beautiful state park with easy, flat trails along the Eno River. The Cole Mill access area has a popular swimming hole in summer. Perfect for toddler nature walks and exploring.",
    address: "6101 Cole Mill Rd, Durham, NC 27705",
    latitude: 36.0614,
    longitude: -79.0094,
    activity_type: "nature_trail",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "8:00 AM - 6:00 PM",
      tuesday: "8:00 AM - 6:00 PM",
      wednesday: "8:00 AM - 6:00 PM",
      thursday: "8:00 AM - 6:00 PM",
      friday: "8:00 AM - 6:00 PM",
      saturday: "8:00 AM - 6:00 PM",
      sunday: "8:00 AM - 6:00 PM"
    },
    website: "https://www.ncparks.gov/eno-river-state-park"
  },
  {
    name: "Coker Arboretum",
    description: "Free 5-acre garden on the UNC campus with winding paths perfect for strollers and little explorers. Beautiful year-round, great for a short outdoor outing.",
    address: "120 Old Mason Farm Rd, Chapel Hill, NC 27514",
    latitude: 35.9115,
    longitude: -79.0512,
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
    website: "https://ncbg.unc.edu/visit/coker-arboretum/"
  },
  {
    name: "UNC Botanical Garden",
    description: "Free botanical garden with easy paths, native plants, and a children's garden. Stroller-friendly and a great calm outing for toddlers.",
    address: "100 Old Mason Farm Rd, Chapel Hill, NC 27517",
    latitude: 35.8984,
    longitude: -79.0447,
    activity_type: "park",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "8:00 AM - 5:00 PM",
      tuesday: "8:00 AM - 5:00 PM",
      wednesday: "8:00 AM - 5:00 PM",
      thursday: "8:00 AM - 5:00 PM",
      friday: "8:00 AM - 5:00 PM",
      saturday: "8:00 AM - 5:00 PM",
      sunday: "1:00 PM - 5:00 PM"
    },
    website: "https://ncbg.unc.edu"
  },
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
    name: "Chapel Hill Community Center",
    description: "Recreation center with gym, indoor track, and drop-in open play. Great rainy day option close to Chapel Hill.",
    address: "120 S Estes Dr, Chapel Hill, NC 27514",
    latitude: 35.9155,
    longitude: -79.0469,
    activity_type: "indoor_play",
    indoor: true,
    cost_level: 1,
    hours: {
      monday: "6:00 AM - 9:00 PM",
      tuesday: "6:00 AM - 9:00 PM",
      wednesday: "6:00 AM - 9:00 PM",
      thursday: "6:00 AM - 9:00 PM",
      friday: "6:00 AM - 8:00 PM",
      saturday: "8:00 AM - 6:00 PM",
      sunday: "1:00 PM - 6:00 PM"
    },
    website: "https://www.townofchapelhill.org/government/departments-services/parks-recreation",
    phone: "(919) 968-2790"
  },
  {
    name: "Kidzu Children's Museum - TreeHouse",
    description: "Outdoor treehouse exhibit at Kidzu with climbing, discovery, and nature play. Separate ticket from the main museum. Great for active toddlers.",
    address: "201 S Estes Dr, Chapel Hill, NC 27514",
    latitude: 35.9116,
    longitude: -79.0469,
    activity_type: "indoor_play",
    indoor: false,
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
  },
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
    name: "Breeze Farm",
    description: "Small family farm near Durham with u-pick produce, farm animals, and a farm store. Kids love meeting the animals and exploring the fields.",
    address: "4621 Bahama Rd, Durham, NC 27705",
    latitude: 36.1180,
    longitude: -78.9838,
    activity_type: "farm",
    indoor: false,
    cost_level: 1,
    hours: {
      monday: "closed",
      tuesday: "closed",
      wednesday: "closed",
      thursday: "closed",
      friday: "10:00 AM - 6:00 PM",
      saturday: "9:00 AM - 5:00 PM",
      sunday: "12:00 PM - 5:00 PM"
    },
    website: "https://www.breezefarm.com"
  },
  {
    name: "Maple View Agricultural Center",
    description: "Working farm with a popular ice cream shop. Watch cows being milked, see farm animals up close, and get delicious farm-fresh ice cream. A Chapel Hill area tradition.",
    address: "3501 Dairyland Rd, Chapel Hill, NC 27516",
    latitude: 36.0050,
    longitude: -79.1020,
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
  },
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
