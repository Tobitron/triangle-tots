# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_31_212527) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.activities", force: :cascade do |t|
    t.string "activity_type", null: false
    t.string "address"
    t.integer "cost_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_date"
    t.jsonb "hours", default: {}
    t.boolean "indoor", default: false, null: false
    t.boolean "is_event", default: false, null: false
    t.datetime "last_synced_at"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "name", null: false
    t.string "phone"
    t.string "registration_url"
    t.string "source_url"
    t.datetime "start_date"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["activity_type"], name: "index_activities_on_activity_type"
    t.index ["cost_level"], name: "index_activities_on_cost_level"
    t.index ["indoor"], name: "index_activities_on_indoor"
    t.index ["is_event"], name: "index_activities_on_is_event"
    t.index ["latitude", "longitude"], name: "index_activities_on_latitude_and_longitude"
    t.index ["start_date", "end_date"], name: "index_activities_on_start_date_and_end_date"
  end

end
