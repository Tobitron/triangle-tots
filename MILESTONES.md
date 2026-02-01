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

## Milestone 2: Location
**Goal:** Factor location into activity list

**Features:**
- First-time user setup - capture home location
- Calculate the distance from home to each activity in distance and driving time
- Show distance + driving time in the card for each activity
- Sort activities by distance, shortest distance comes first 

**User Value:** Parents can see how far away activities are

---

## Milestone 3: "Now" Feed Logic
**Goal:** Implement the core smart recommendation engine

**User Value:** Parents get contextually relevant suggestions for activities available RIGHT NOW, filtered by hours, weather, and location.

### Business Logic Documentation

#### 1. Hours Tracking & "Currently Open" Definition

**Hours Storage:**
- Hours are stored in the `hours` jsonb column with day-of-week keys
- Format: `{ "monday": "10:00 AM - 6:00 PM", "tuesday": "closed", "wednesday": "dawn - dusk" }`
- Three supported patterns:
  1. **Specific times**: `"10:00 AM - 6:00 PM"` - parsed with regex and compared to current time
  2. **Relative times**: `"dawn - dusk"` - converted to fixed times (7 AM - 7 PM for MVP)
  3. **Closed**: `"closed"` - activity marked as closed, not shown in "Now" feed

**"Currently Open" Logic:**
An activity is included in the "Now" feed if:
- It is **open right now** (current time falls within hours range), OR
- It will **open within the next 2 hours**

**Status Badge Logic:**
- **"Open until 6:00 PM"** (green badge) - Activity is currently open, shows closing time
- **"Closing soon"** (yellow badge) - Activity is open but closes within 1 hour
- **"Opens at 2:00 PM"** (blue badge) - Activity is closed but opens within 2 hours

**Edge Cases:**
- Activities with no hours: Not shown in "Now" feed
- "dawn - dusk" after 7 PM: Marked as closed
- Multiple time zones: All times calculated in Eastern Time (Triangle area)

#### 2. Weather Integration & Filtering

**Weather API:**
- Service: WeatherAPI.com (free tier: 1M calls/month)
- Data fetched: Current conditions + hourly forecast for next 6-8 hours
- Caching: 30 minutes in Rails.cache with key `"weather:#{lat}:#{lng}:#{hour}"`
- Location: User's home location (from Milestone 2), falls back to Durham (36.0014, -78.9015) if not set

**Weather Filtering Strategy:**
The system analyzes the hourly forecast and counts hours with **precipitation probability > 60%**:

1. **:hide_outdoor** (> 3 hours of rain)
   - **Trigger**: More than 3 hours with >60% rain/snow probability
   - **Action**: Hide all outdoor activities completely (filter out `indoor: false`)
   - **Example**: Steady rain forecasted for 4+ hours → only show libraries, museums, indoor play centers

2. **:deprioritize_outdoor** (1-3 hours of rain)
   - **Trigger**: Between 1-3 hours with >60% rain/snow probability
   - **Action**: Keep outdoor activities but move them below indoor activities in the list
   - **Sorting**: Indoor activities (sorted by distance) appear first, then outdoor activities (sorted by distance)
   - **Example**: Light rain shower expected for 2 hours → playgrounds appear after libraries but are still visible

3. **:normal** (0 hours of rain)
   - **Trigger**: No hours with >60% rain/snow probability
   - **Action**: No weather-based filtering or penalty
   - **Sorting**: All activities sorted only by distance
   - **Example**: Sunny day → parks and playgrounds ranked normally

**Weather Display:**
- Weather summary at top of page: "☀️ Sunny today" or "🌧️ Rain expected - showing indoor activities only"
- Weather icons: ☀️ (sun/clear), ☁️ (cloudy), 🌧️ (rain), ❄️ (snow), ⛈️ (storm)
- No per-activity weather warnings for MVP

**Weather API Failure Handling:**
- If API call fails: Log error, return default weather (assume good weather)
- Effect: Show all activities with :normal strategy
- User sees all activities sorted by distance

#### 3. View Modes & Navigation

**Two View Modes:**

1. **"Now" View** (default)
   - Smart filtered feed based on hours + weather
   - Shows status badges on cards
   - Activities sorted by distance with weather penalty (if applicable)
   - Default landing page

2. **"All Activities" View**
   - Unfiltered list of all activities (Milestone 2 behavior)
   - Sorted only by distance
   - No status badges
   - No weather filtering

**Tab Navigation:**
- Two tabs at top: "Now" and "All Activities"
- Active tab highlighted with blue underline
- Both tabs preserve location parameters (home_lat, home_lng)

#### 4. Sorting & Ranking Logic

**"Now" Feed Sorting:**
```
Primary sort factors (in order):
1. Weather penalty (if strategy is :deprioritize_outdoor)
   - Indoor activities (indoor: true) ranked first
   - Outdoor activities (indoor: false) ranked second
2. Distance availability
   - Activities with distance calculated ranked first
   - Activities without distance (no coordinates) ranked last
3. Distance (ascending)
   - Closest activities appear first
```

**Example Sort Order (deprioritize_outdoor strategy):**
1. Kidzu Children's Museum (indoor, 0.5 mi)
2. Chapel Hill Library (indoor, 1.2 mi)
3. Marbles Kids Museum (indoor, 10.5 mi)
4. Homestead Park Playground (outdoor, 0.3 mi)  ← appears after all indoor despite being closer
5. Duke Gardens (outdoor, 2.1 mi)

**"All Activities" Sorting:**
- Simple distance-based sort (Milestone 2 behavior)
- No weather penalty applied
- Closest activities appear first regardless of indoor/outdoor status

#### 5. Empty State Handling

**Scenario**: No activities match the "Now" feed filters (closed + bad weather)

**Strategy**: Relax filters and show "Opens soon" activities

**Implementation:**
1. Filter activities that will open within next 12 hours OR will open tomorrow
2. Take up to 10 activities
3. Display with blue "Opens at X" badges
4. Show message: "Nothing open right now, but these open soon:"

**Example:**
- It's 8 PM on Monday, everything is closed
- Show activities opening tomorrow morning with "Opens at 9:00 AM" badges

#### 6. Technical Implementation

**New Services:**

1. **WeatherService** (`app/services/weather_service.rb`)
   - `fetch_forecast(lat, lng)`: Fetches weather from API with caching
   - `analyze_rain_forecast(forecast_hours)`: Analyzes forecast and returns strategy symbol
   - Handles API failures gracefully

2. **HoursParser** (`app/services/hours_parser.rb`)
   - `open_at?(hours_string, time)`: Checks if activity is open at given time
   - `opens_within?(hours_string, current_time, hours)`: Returns opening time if opens soon
   - `closes_within?(hours_string, current_time, hours)`: Returns closing time if closes soon
   - Parses three format types: specific times, "dawn - dusk", "closed"

3. **ActivityFilter** (`app/services/activity_filter.rb`)
   - `filter_for_now(activities, weather_strategy, current_time)`: Main filtering logic
   - `apply_weather_filter(activities, weather_strategy)`: Weather-based filtering
   - `relax_filters_for_empty_state(activities, current_time)`: Empty state handling

**Updated Models:**
- Activity model adds:
  - `attr_accessor :status, :status_time` - virtual attributes for status display
  - `hours_today` - returns hours string for current day
  - `open_at?(time)` - checks if open at given time
  - `opens_within?(hours)` - checks if opens soon
  - `closes_within?(hours)` - checks if closes soon
  - `calculate_status` - determines current status and time for badges

**Controller Flow:**
1. Extract home location from params (or use Durham default)
2. Fetch weather forecast for location
3. Analyze forecast → determine weather strategy
4. Check view mode ("now" or "all")
5. If "now": Filter activities → Calculate status for each → Sort with weather penalty
6. If "all": Just calculate distance and sort
7. Render view with tabs, weather indicator, status badges

**Time Zone:**
- Rails configured to use `"Eastern Time (US & Canada)"`
- All time comparisons use `Time.current` (respects Rails time zone)

**Caching:**
- Weather data cached for 30 minutes
- Cache key includes lat, lng, and current hour
- Invalidates hourly to ensure fresh forecast data

#### 7. User Experience Flow

**First-Time User (No Location Set):**
1. Browser prompts for location permission
2. Location saved to localStorage
3. Page reloads with location params
4. Weather fetched for user's location
5. "Now" feed shows filtered activities

**Typical Usage (Has Location):**
1. User visits app → "Now" tab active by default
2. Sees weather summary at top: "☀️ Sunny today"
3. Sees activities with status badges: "Open until 6 PM"
4. Activities sorted by distance (closest first)
5. Can switch to "All Activities" tab to see unfiltered list

**Rainy Day:**
1. User visits app → "Now" tab active
2. Sees weather summary: "🌧️ Rain expected - showing indoor activities only"
3. Only indoor activities appear in list
4. Outdoor activities completely hidden (if >3 hours of rain)
5. User can switch to "All Activities" to see outdoor options anyway

**Evening (Most Places Closed):**
1. User visits app → "Now" tab active
2. Few/no activities currently open
3. Sees "Nothing open right now, but these open soon:"
4. Shows activities opening tomorrow with "Opens at 9:00 AM" badges

**Features Implemented:**
- ✅ Hours tracking and parsing (3 formats supported)
- ✅ Weather API integration with WeatherAPI.com
- ✅ Smart filtering by hours + weather + location
- ✅ Status badges (open, closing soon, opens soon)
- ✅ Tab navigation (Now vs All Activities)
- ✅ Weather indicator at top of page
- ✅ Empty state handling
- ✅ Weather-based sorting/penalty
- ✅ 30-minute weather caching
- ✅ Time zone handling (Eastern Time)

**Limitations & Future Enhancements:**
- Dawn/dusk uses fixed times (7 AM - 7 PM) instead of actual sunrise/sunset
- No temperature-based filtering (only precipitation)
- No user preference to override weather filtering
- No per-activity weather warnings
- No driving time (only straight-line distance)

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
