# Triangle Tots Activity App - Implementation Milestones

## MVP Scope Summary

A mobile-responsive web app for parents in the Chapel Hill/Durham/Triangle area to discover age-appropriate activities for their toddlers. The app combines evergreen activities (playgrounds, libraries, etc.) with one-time events, using smart recommendation logic based on weather, availability, and user preferences.

**Key Features:**
- "Now" feed - currently available activities
- "Weekend" feed - upcoming weekend events
- Activity logging with thumbs up/down ratings
- Smart recommendations (weather, recency, preferences)
- Filters: indoor/outdoor, cost, type, location
- Target audience: Parents of 3-year-olds only
- Local storage (no user accounts for MVP)

**Tech Stack:**
- Backend: Ruby on Rails 7+
- Frontend: Hotwire (Turbo + Stimulus)
- Styling: Tailwind CSS
- Database: PostgreSQL via Supabase
- Weather: Free weather service API (TBD)

---

## Milestone 1: Basic Activity Browser
**Goal:** Get a minimal working app that displays activities

**Features:**
- Rails 7 new app setup with Hotwire and Tailwind CSS
- Database schema and migrations (Activity model)
- Seed database with initial evergreen activities
- Simple list/grid view of all activities with Turbo Frames
- Activity details page (name, description, address, hours, cost, type)
- Basic responsive layout with Tailwind

**User Value:** Parents can browse and view details of available activities

---

## Milestone 2: Filtering & Personalization Setup
**Goal:** Let parents filter activities relevant to them

**Features:**
- First-time user setup (capture location preference)
- Indoor/outdoor filter
- Cost level filter
- Activity type filter
- Location/distance filter
- Filter UI controls on main view

**User Value:** Parents see only relevant activities based on their preferences and location

---

## Milestone 3: "Now" Feed Logic
**Goal:** Implement the core smart recommendation engine

**Features:**
- Store and track activity hours
- Weather API integration
- "Now" feed that filters by:
  - Currently open (based on hours)
  - Weather-appropriate (indoor if raining)
  - Location preference
- Weather-aware UI indicators

**User Value:** Parents get contextually relevant suggestions for RIGHT NOW

---

## Milestone 4: Activity Logging & Learning
**Goal:** Learn user preferences and avoid repetition

**Features:**
- Local storage setup for user data
- Thumbs up/down rating system on activities
- Activity history tracking (what they've done and when)
- Enhanced "Now" feed recommendations:
  - Avoid suggesting recently done activities
  - Boost activities they've rated positively
  - Variety logic (don't show same type repeatedly)

**User Value:** App learns preferences and provides fresh, personalized suggestions

---

## Milestone 5: Weekend Feed & Events
**Goal:** Add event support and weekend planning

**Features:**
- Events data model (vs evergreen activities)
- External event feed integration
- Event parsing and database sync
- "Weekend" feed view
- Date-based filtering for upcoming weekend
- Event-specific details (start/end dates, registration links)

**User Value:** Parents can plan ahead for weekend activities and discover special events

---

## Milestone 6: Polish & Production-Ready
**Goal:** Make the app production-ready and delightful to use

**Features:**
- Mobile-responsive design refinement
- Loading states and skeletons
- Error handling and fallbacks
- Empty states (no activities match filters)
- Performance optimization
- Analytics/tracking (optional)
- Favicon, meta tags, PWA manifest

**User Value:** Polished, reliable experience that feels professional

---

## Notes for Future Implementation

**Deferred to Post-MVP:**
- User accounts and cross-device sync
- Search functionality
- Favorites/bookmarks
- Social features (sharing, reviews)
- Push notifications
- Photo uploads
- Calendar integration

**Open Questions to Resolve:**
- Weekend feed date range (Fri-Sun? Just Sat-Sun? Next 7 days?)
- Which external event feed/source to use
- Which free weather API service (OpenWeatherMap, WeatherAPI, etc.)
- Database schema details (single activities table vs separate events table)

**Decisions Made:**
- Target audience: 3-year-olds only (all activities curated for this age)
- Rating mechanism: Thumbs up/down
- No age filtering needed
- Tech stack: Rails 7+ with Hotwire (Turbo + Stimulus) and Tailwind CSS
- Database: PostgreSQL
