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
    address: "1000 Sumac Rd, Chapel Hill, NC 27516",
    latitude: 35.8793,
    longitude: -79.0656,
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
    address: "501 Weaver Dairy Rd, Chapel Hill, NC 27514",
    latitude: 35.9600,
    longitude: -79.0335,
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
    latitude: 35.7791,
    longitude: -78.6624,
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
    address: "100 Northern Park Dr, Chapel Hill, NC 27516",
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
    address: "101 Williams St, Carrboro, NC 27510",
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
    latitude: 35.9258,
    longitude: -79.0327,
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
    latitude: 35.9111,
    longitude: -79.0214,
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
    address: "300 Northern Park Dr, Chapel Hill, NC 27516",
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
    latitude: 35.9129,
    longitude: -79.0638,
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
    latitude: 35.9321,
    longitude: -79.0358,
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
    latitude: 35.9949,
    longitude: -78.8967,
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
    latitude: 36.0743,
    longitude: -79.1007,
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
    latitude: 35.7822,
    longitude: -78.6395,
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
    latitude: 35.9139,
    longitude: -79.0504,
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
    latitude: 36.0294,
    longitude: -78.8993,
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
    address: "201 S Estes Dr, Chapel Hill, NC 27514",
    latitude: 35.9279,
    longitude: -79.0272,
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
    latitude: 36.0785,
    longitude: -79.0051,
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
    address: "399 E Cameron Ave, Chapel Hill, NC 27514",
    latitude: 35.9135,
    longitude: -79.0467,
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
    latitude: 35.8993,
    longitude: -79.0321,
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
    address: "420 Anderson St, Durham, NC 27705",
    latitude: 36.0021,
    longitude: -78.9315,
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
    latitude: 35.7637,
    longitude: -78.7140,
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

# Hikes & Nature Walks
Activity.create!([
  {
    name: "Bolin Creek Trail",
    description: "Paved greenway trail following Bolin Creek from Chapel Hill to Carrboro. Flat, stroller-friendly, and shaded. Kids love spotting turtles and crawfish in the creek. Multiple access points make it easy to do a short out-and-back.",
    address: "200 N Greensboro St, Carrboro, NC 27510",
    latitude: 35.9121,
    longitude: -79.0710,
    activity_type: "nature_trail",
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
    name: "Johnston Mill Nature Preserve",
    description: "Quiet 296-acre preserve with easy wooded trails and a creek crossing. Short loop options (under 1 mile) make it great for toddler-paced walks. Watch for deer, birds, and wildflowers. No restrooms — come prepared.",
    address: "2713 Mt Sinai Rd, Chapel Hill, NC 27514",
    latitude: 35.9954,
    longitude: -79.0539,
    activity_type: "nature_trail",
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
    website: "https://www.triangleland.org/explore/nature-preserves/johnston-mill"
  },
  {
    name: "Carolina North Forest",
    description: "700-acre UNC research forest with wide gravel fire roads perfect for toddlers and strollers. Gentle terrain, creeks to peek at, and lots of birds. The Bolin Creek entrance is the easiest access point.",
    address: "1089 Municipal Dr, Chapel Hill, NC 27599",
    latitude: 35.9392,
    longitude: -79.0573,
    activity_type: "nature_trail",
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
    website: "https://facilities.unc.edu/operations/carolina-north-forest/"
  },
  {
    name: "Leigh Farm Park",
    description: "Historic 127-acre park with wide, flat trails through meadows and woods. The 1-mile paved loop is stroller-friendly and the open fields are great for toddlers to run. Benches and a picnic shelter along the trail.",
    address: "370 Leigh Farm Rd, Durham, NC 27707",
    latitude: 35.9228,
    longitude: -78.9831,
    activity_type: "nature_trail",
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
    website: "https://www.dprplaymore.org/facilities/leigh-farm-park"
  },
  {
    name: "Occoneechee Mountain State Natural Area",
    description: "Short hikes with big views. The Overlook Trail (~0.6 miles) leads to a bluff overlooking the Eno River — toddlers can handle it with a carrier backup. Brown Elfin Knob trail has unique rock outcrops. Hillsborough's hidden gem.",
    address: "625 Virginia Cates Rd, Hillsborough, NC 27278",
    latitude: 36.0630,
    longitude: -79.1150,
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
    website: "https://www.ncparks.gov/state-natural-areas/occoneechee-mountain-state-natural-area"
  },
  {
    name: "Little River Regional Park",
    description: "Peaceful 391-acre park on the Orange-Durham county line. Wide, well-maintained trails through forest with creek crossings on bridges. The 1.3-mile Little River Loop is flat and easy for little legs. Playground at the trailhead too.",
    address: "301 Little River Park Way, Rougemont, NC 27572",
    latitude: 36.1510,
    longitude: -79.0870,
    activity_type: "nature_trail",
    indoor: false,
    cost_level: 0,
    hours: {
      monday: "8:00 AM - sunset",
      tuesday: "8:00 AM - sunset",
      wednesday: "8:00 AM - sunset",
      thursday: "8:00 AM - sunset",
      friday: "8:00 AM - sunset",
      saturday: "8:00 AM - sunset",
      sunday: "8:00 AM - sunset"
    },
    website: "https://www.eno.org/little-river-park/"
  },
  {
    name: "Brumley Forest Nature Preserve",
    description: "164-acre preserve with easy 2-mile loop trail through hardwood forest. Flat, wide trail is good for confident walkers. Quiet and uncrowded — a nice escape. No restrooms or water, so bring supplies.",
    address: "3620 Old NC 10, Durham, NC 27705",
    latitude: 36.0280,
    longitude: -79.0130,
    activity_type: "nature_trail",
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
    website: "https://www.triangleland.org/explore/nature-preserves/brumley-forest"
  },
  {
    name: "Fred G. Bond Metro Park",
    description: "310-acre park in Cary with paved lakeside trails, a boathouse, and a large playground. The 2-mile Lake Trail is flat, paved, and stroller-perfect with water views the whole way. Boat rentals available seasonally.",
    address: "801 High House Rd, Cary, NC 27513",
    latitude: 35.7853,
    longitude: -78.8207,
    activity_type: "nature_trail",
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
    website: "https://www.townofcary.org/recreation-enjoyment/parks-greenways-environment/parks/fred-g-bond-metro-park"
  }
])

# Indoor Play
Activity.create!([
  {
    name: "Chapel Hill Community Center",
    description: "Recreation center with gym, indoor track, and drop-in open play. Great rainy day option close to Chapel Hill.",
    address: "120 S Estes Dr, Chapel Hill, NC 27514",
    latitude: 35.9258,
    longitude: -79.0327,
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
    latitude: 35.9279,
    longitude: -79.0272,
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
    latitude: 35.7788,
    longitude: -78.6362,
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
  },
  {
    name: "Notasium",
    description: "Music-based indoor play space with 3,000 sq ft of hands-on instruments and sound exploration for kids. All-day pass lets you come and go. Also offers music lessons and classes.",
    address: "3750 Durham-Chapel Hill Blvd, Durham, NC 27707",
    latitude: 35.9713,
    longitude: -78.9545,
    activity_type: "indoor_play",
    indoor: true,
    cost_level: 1,
    hours: {
      monday: "9:30 AM - 6:30 PM",
      tuesday: "9:30 AM - 6:30 PM",
      wednesday: "9:30 AM - 6:30 PM",
      thursday: "9:30 AM - 6:30 PM",
      friday: "9:30 AM - 6:30 PM",
      saturday: "9:00 AM - 11:00 AM",
      sunday: "closed"
    },
    website: "https://durham.notasium.com",
    phone: "(919) 230-9321"
  }
])

# Farms
Activity.create!([
  {
    name: "Breeze Farm",
    description: "Small family farm near Durham with u-pick produce, farm animals, and a farm store. Kids love meeting the animals and exploring the fields.",
    address: "4621 Bahama Rd, Durham, NC 27705",
    latitude: 36.2008,
    longitude: -78.8461,
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
  },
  {
    name: "1870 Farm",
    description: "17-acre educational farm with an Animal Village petting zoo featuring goats, sheep, ponies, donkeys, pigs, alpacas, and more. Kids can feed animals, fish, and take electric tractor rides. Advance booking required.",
    address: "1224 Old Lystra Rd, Chapel Hill, NC 27517",
    latitude: 35.8733,
    longitude: -79.0510,
    activity_type: "farm",
    indoor: false,
    cost_level: 1,
    hours: {
      monday: "closed",
      tuesday: "closed",
      wednesday: "10:00 AM - 1:00 PM",
      thursday: "10:00 AM - 1:00 PM",
      friday: "10:00 AM - 1:00 PM",
      saturday: "10:00 AM - 1:00 PM",
      sunday: "10:00 AM - 1:00 PM"
    },
    website: "https://www.1870farm.com",
    phone: "(919) 448-8175"
  }
])

puts "Created #{Activity.count} activities!"
puts "Activity types: #{Activity.group(:activity_type).count}"
