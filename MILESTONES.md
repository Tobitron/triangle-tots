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
- No temperature-based filtering (only precipitation)
- No user preference to override weather filtering
- No per-activity weather warnings
- No driving time (only straight-line distance)

---

## Milestone 4: Activity Logging & Learning
**Goal:** Learn user preferences and avoid repetition using localStorage-based personalization

**User Value:** App learns preferences and provides fresh, personalized suggestions

### Business Logic Documentation

#### 1. Data Storage Strategy

**Current State (MVP):**
- Store user interactions in browser localStorage (no accounts required)
- Key: `triangleTots_activityInteractions`
- Persists across sessions on same device
- Data structure designed for easy migration to database

**Future State (Post-MVP):**
- Migrate to PostgreSQL `user_activity_interactions` table when accounts added
- Import localStorage data when user creates account
- Sync across devices

**LocalStorage Schema:**
```javascript
{
  "version": "1.0",
  "interactions": {
    "1": {  // activity_id as key
      "rating": 1,           // 1 = thumbs up, -1 = thumbs down, null = unrated
      "completions": [       // Array of completion timestamps (ISO 8601)
        "2026-01-15T14:30:00Z",
        "2026-01-08T10:15:00Z"
      ],
      "lastCompleted": "2026-01-15T14:30:00Z",  // Denormalized for quick recency checks
      "updatedAt": "2026-01-15T14:30:00Z"
    }
  }
}
```

#### 2. Rating System

**UI Components:**
- Simple thumbs up/down buttons on each activity card
- "Mark as Done" button to track completed activities
- Visual feedback: rated activities show colored borders (green for 👍, red for 👎)

**Rating Values:**
- **Thumbs up (+1)**: "Would go again" - boosts activity in recommendations
- **Thumbs down (-1)**: "Not for us" - lowers activity in recommendations
- **Unrated (null)**: No preference impact, sorted by other factors

**User Actions:**
- Can rate without marking done (planning ahead)
- Can mark done without rating (just tracking)
- Can change rating anytime (overwrite previous value)

#### 3. Activity History Tracking

**Completion Tracking:**
- Each time user marks activity as "done", timestamp is added to `completions` array
- `lastCompleted` field updated for quick lookup
- Full history preserved for potential future features (frequency analysis, seasonal patterns)

**Recency Windows:**
- **0-7 days**: Recently completed (hard filter - hide completely)
- **8-21 days**: Moderately recent (soft filter - apply penalty)
- **22+ days**: Old completion (no penalty)

#### 4. Enhanced "Now" Feed Recommendation Algorithm

**Core Principle:** Multi-factor scoring system that combines location, user preferences, recency, variety, and weather into a single composite score.

**Scoring Formula (Additive):**
```
score = 0

// Factor 1: Distance penalty (closer = better)
score -= (distance_in_miles × 1.0)

// Factor 2: Rating boost/penalty
if thumbs_up:   score += 5.0
if thumbs_down: score -= 5.0

// Factor 3: Recency filtering
if completed < 7 days ago:   FILTER OUT (exclude from results entirely)
if completed 8-21 days ago:  score -= 3.0

// Factor 4: Variety penalty
if activity_type appears in previous 3 results: score -= 2.0

// Factor 5: Weather penalty (from Milestone 3)
if deprioritize_outdoor AND outdoor: score -= 4.0
```

**Weight Rationale:**
- **Distance (1.0)**: Base factor - 1 point penalty per mile
- **Rating (±5.0)**: Strong signal - user preference should override moderate distance differences
- **Recency hide (filter out)**: Complete exclusion prevents repetition
- **Recency penalty (-3.0)**: Moderate discouragement for recent visits
- **Variety (-2.0)**: Ensures diversity in top results without being too rigid
- **Weather (-4.0)**: Existing logic from Milestone 3, maintained for consistency

#### 5. Recency Logic: "Avoid Recently Done Activities"

**Strategy:** Hide for 7 days, deprioritize for next 14 days

**Implementation:**
1. **Hard filter (0-7 days)**: Activity completely removed from "Now" feed
   - User sees variety of new options
   - Prevents "just went there yesterday" suggestions
   - Filter applied before scoring algorithm runs

2. **Soft penalty (8-21 days)**: Activity appears but ranked lower
   - Score reduced by -3.0 points
   - Still visible but pushed down by ~3 miles worth of distance
   - Allows rediscovery after cooling-off period

3. **No penalty (22+ days)**: Activity ranked normally
   - Completions older than 3 weeks don't affect score
   - User can "rediscover" favorite spots

**Edge Case - All Activities Recently Completed:**
- If hard filter removes all activities, relax to show them anyway
- Display message: "You've been busy! You've visited all nearby activities recently. Here are some to revisit:"
- Show special badge: "Visited recently" on those cards

#### 6. Rating Logic: "Boost Positively Rated Activities"

**Thumbs Up (+5.0 points):**
- Significant boost equivalent to being ~5 miles closer
- Example: Library at 6 miles with thumbs up scores same as unrated library at 1 mile
- User's favorites consistently appear near top of feed

**Thumbs Down (-5.0 points):**
- Significant penalty - activity appears 5 miles farther than it is
- Still visible (not hidden) unless also recently completed
- Allows user to filter out activities that don't fit their family

**No Rating (0 points):**
- New activities or unrated ones sorted purely by distance + variety + weather
- Cold-start problem: new users see distance-based ranking until they start rating

**Edge Case - All Activities Rated Down:**
- Don't hide activities even if thumbs down
- Still show them sorted by "least bad" (highest score)
- Suggestion: Show message "Showing activities even though you've passed on them - try changing location to explore new areas"

#### 7. Variety Logic: "Don't Show Same Type Repeatedly"

**Strategy:** Penalize consecutive same-type activities in top results

**Implementation:**
- Use sliding window of top 3 results
- Track activity types already shown in positions 0, 1, 2
- If position 3 would be same type as position 2 or 1, apply -2.0 penalty
- Re-sort and check again

**Example Without Variety Penalty:**
```
1. Playground A (playground) - 1.0 mi
2. Playground B (playground) - 1.2 mi
3. Playground C (playground) - 1.5 mi
4. Library A (library) - 1.8 mi
5. Park A (park) - 2.0 mi
```

**Example With Variety Penalty:**
```
1. Playground A (playground) - 1.0 mi     [first playground, no penalty]
2. Library A (library) - 1.8 mi           [different type, promoted]
3. Playground B (playground) - 1.2 mi     [duplicate type but high score]
4. Park A (park) - 2.0 mi                 [different type, promoted]
5. Playground C (playground) - 1.5 mi     [duplicate type, pushed down]
```

**Variety Window Size:** 3 positions
- Only looks at immediate previous results
- Prevents top 5 from being all playgrounds
- Doesn't overly constrain the list

**Edge Case - Activity Type Dominance:**
- If >70% of nearby activities are same type (e.g., only playgrounds in area), disable variety penalty
- Accept geographic reality instead of forcing artificial diversity
- Example: Rural area with 5 playgrounds, 1 library → show playgrounds normally

#### 8. Sorting Process & Integration

**Step-by-Step Algorithm:**

1. **Pre-filter:** Remove activities completed in last 7 days (hard filter)
2. **Initial scoring:** Calculate score for each activity (distance + rating + recency penalty + weather)
3. **Initial sort:** Order by score descending
4. **Variety pass:** Walk through top 5 results, apply variety penalty if needed
5. **Final sort:** Re-order by adjusted scores
6. **Return:** Sorted list of activities

**Integration with Existing Logic:**
- Replaces `sort_with_weather_penalty` in ActivitiesController
- Maintains weather filtering from Milestone 3
- Preserves status badges (open, closing soon, opens soon)
- Works with both "Now" and "All" views (only applied to "Now")

**Performance:**
- Sorting complexity: O(n log n) where n = ~20-50 activities
- Typical execution: <10ms on modern devices
- No server-side caching needed for MVP

#### 9. Technical Implementation

**New Service:**
- **RecommendationScorer** (`app/services/recommendation_scorer.rb`)
  - `score(activity, interactions, home_lat, home_lng, weather_strategy, position, previous_types)`: Calculate composite score
  - `sort_with_scores(activities, interactions, ...)`: Main sorting method with variety logic
  - `days_since_completion(timestamp)`: Calculate recency in days
  - Configurable weight constants for easy tuning

**JavaScript Module:**
- **ActivityInteractions** (`app/views/layouts/application.html.erb`)
  - `rate(activityId, rating)`: Store thumbs up/down in localStorage
  - `markDone(activityId)`: Add completion timestamp
  - `getAllInteractions()`: Export for server-side scoring
  - `updateButtonStates()`: Update UI without page reload
  - Manages localStorage CRUD operations

**Controller Updates:**
- `ActivitiesController#index`:
  - Accept optional `interactions` parameter (JSON from localStorage)
  - Pass interactions to RecommendationScorer
  - Fallback to distance-based sorting if no interactions

**View Updates:**
- `app/views/activities/index.html.erb`:
  - Add 3 buttons to each card: 👍 Like, 👎 Pass, ✓ Done
  - Show visual state (colored borders for rated activities)
- `app/views/activities/show.html.erb`:
  - Add rating section with larger buttons
  - "Mark as Done" button redirects to Now feed

#### 10. Future Database Migration

**Database Schema (when user accounts added):**

```sql
CREATE TABLE user_activity_interactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  activity_id INTEGER NOT NULL REFERENCES activities(id),

  rating INTEGER DEFAULT 0 NOT NULL,  -- -1, 0, or 1
  last_completed_at TIMESTAMP,
  completion_count INTEGER DEFAULT 0 NOT NULL,
  completion_history JSONB DEFAULT '[]',

  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  UNIQUE(user_id, activity_id)
);

CREATE INDEX idx_user_activity ON user_activity_interactions(user_id, activity_id);
CREATE INDEX idx_user_recency ON user_activity_interactions(user_id, last_completed_at);
CREATE INDEX idx_user_rating ON user_activity_interactions(user_id, rating);
```

**Migration Process:**
1. User creates account
2. Client POSTs localStorage data to `/api/migrate_interactions`
3. Server creates `user_activity_interactions` records
4. Controller switches from localStorage to database queries
5. Client clears localStorage after successful migration

**Features Implemented:**
- ✅ LocalStorage-based interaction tracking
- ✅ Thumbs up/down rating system
- ✅ Activity completion tracking with timestamps
- ✅ Recency filtering (hide 7 days, penalize 21 days)
- ✅ Rating-based score boosting/penalty
- ✅ Variety penalty for consecutive same-type activities
- ✅ Multi-factor recommendation scoring algorithm
- ✅ Database schema designed for future migration
- ✅ Edge case handling (empty history, all rated down, type dominance)

**Limitations & Future Enhancements:**
- No cross-device sync (localStorage is device-specific)
- No collaborative filtering (no user similarity analysis)
- Fixed scoring weights (could be made user-configurable)
- No time-of-day preferences (e.g., prefer morning vs afternoon activities)
- No seasonal patterns (e.g., splash pads in summer)

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





**Decisions Made:**
- Target audience: 3-year-olds only (all activities curated for this age)
- Rating mechanism: Thumbs up/down
- No age filtering needed
- Tech stack: Rails 7+ with Hotwire (Turbo + Stimulus) and Tailwind CSS
- Database: PostgreSQL
