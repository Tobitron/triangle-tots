# Triangle Tots Database Schema

## Activities Table

Single table for both evergreen activities and one-time events.

### Schema

```ruby
create_table "activities", force: :cascade do |t|
  # Basic info
  t.string "name", null: false
  t.text "description"
  t.string "address"
  t.decimal "latitude", precision: 10, scale: 6
  t.decimal "longitude", precision: 10, scale: 6

  # Classification
  t.string "activity_type", null: false # enum - see Activity Types below
  t.boolean "is_event", default: false, null: false
  t.boolean "indoor", default: false, null: false
  t.integer "cost_level", default: 0, null: false # 0=free, 1=$, 2=$$, 3=$$$

  # Hours (for evergreen activities)
  t.jsonb "hours", default: {}

  # Event-specific fields (null for evergreen activities)
  t.datetime "start_date"
  t.datetime "end_date"
  t.string "registration_url"

  # Contact & metadata
  t.string "website"
  t.string "phone"
  t.string "source_url" # where event data was pulled from
  t.datetime "last_synced_at" # for event feed sync tracking

  # Timestamps
  t.timestamps

  # Indexes
  t.index ["activity_type"]
  t.index ["is_event"]
  t.index ["indoor"]
  t.index ["cost_level"]
  t.index ["latitude", "longitude"]
  t.index ["start_date", "end_date"]
end
```

## Activity Types (Enum)

Predefined types for filtering and categorization:

- `playground`
- `library`
- `museum`
- `park`
- `splash_pad`
- `indoor_play`
- `farm`
- `nature_trail`
- `class`
- `event`
- `restaurant`

**Implementation in Rails:**
```ruby
class Activity < ApplicationRecord
  enum activity_type: {
    playground: 'playground',
    library: 'library',
    museum: 'museum',
    park: 'park',
    splash_pad: 'splash_pad',
    indoor_play: 'indoor_play',
    farm: 'farm',
    nature_trail: 'nature_trail',
    class: 'class',
    event: 'event',
    restaurant: 'restaurant'
  }
end
```

## Hours JSONB Structure

For evergreen activities, the `hours` field stores weekly hours in JSONB format:

```json
{
  "monday": "9:00 AM - 5:00 PM",
  "tuesday": "9:00 AM - 5:00 PM",
  "wednesday": "9:00 AM - 5:00 PM",
  "thursday": "9:00 AM - 5:00 PM",
  "friday": "9:00 AM - 5:00 PM",
  "saturday": "10:00 AM - 4:00 PM",
  "sunday": "closed"
}
```

**Special cases:**
- `"closed"` - location is closed that day
- `null` or missing key - hours unknown
- `"24 hours"` - open 24 hours
- Multiple periods: `"9:00 AM - 12:00 PM, 1:00 PM - 5:00 PM"`

## Example Records

### Evergreen Activity (Playground)
```ruby
{
  name: "Homestead Park Playground",
  description: "Large playground with slides, swings, and climbing structures. Shaded picnic areas available.",
  address: "200 Homestead Rd, Chapel Hill, NC 27516",
  latitude: 35.9132,
  longitude: -79.0558,
  activity_type: "playground",
  is_event: false,
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
  website: "https://www.townofchapelhill.org/government/departments-services/parks-recreation/parks-greenways-trails/parks/homestead-park",
  phone: nil
}
```

### One-Time Event
```ruby
{
  name: "Toddler Music & Movement Class",
  description: "Interactive music class for 2-4 year olds. Songs, instruments, and dancing!",
  address: "Durham Arts Council, 120 Morris St, Durham, NC 27701",
  latitude: 35.9940,
  longitude: -78.8986,
  activity_type: "class",
  is_event: true,
  indoor: true,
  cost_level: 2,
  hours: nil,
  start_date: "2026-02-07 10:00:00",
  end_date: "2026-02-07 10:45:00",
  registration_url: "https://example.com/register",
  website: "https://durhamarts.org",
  phone: "(919) 560-2787",
  source_url: "https://durhamarts.org/events"
}
```

## Validations

```ruby
class Activity < ApplicationRecord
  validates :name, presence: true
  validates :activity_type, presence: true, inclusion: { in: activity_types.keys }
  validates :cost_level, inclusion: { in: 0..3 }

  # Event-specific validations
  validates :start_date, :end_date, presence: true, if: :is_event?
  validate :end_date_after_start_date, if: :is_event?

  # Evergreen-specific validations
  validates :hours, presence: true, unless: :is_event?

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
```

## Future Considerations (Post-MVP)

### Activity Logs Table (for user tracking)
When we move beyond local storage, we'll need:

```ruby
create_table "activity_logs" do |t|
  t.references :activity, null: false, foreign_key: true
  t.string :device_id, null: false # anonymous device identifier
  t.integer :rating # 1 = thumbs up, -1 = thumbs down
  t.datetime :completed_at, null: false

  t.timestamps

  t.index [:device_id, :activity_id]
  t.index [:device_id, :completed_at]
end
```

### Categories Table (if we want nested categorization)
For more complex filtering, we could add:

```ruby
create_table "categories" do |t|
  t.string :name, null: false
  t.string :parent_id
  t.timestamps
end

create_table "activity_categories" do |t|
  t.references :activity, null: false, foreign_key: true
  t.references :category, null: false, foreign_key: true
  t.timestamps
end
```

But for MVP, the enum `activity_type` is sufficient.
