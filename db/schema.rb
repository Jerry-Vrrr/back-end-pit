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

ActiveRecord::Schema[7.1].define(version: 2024_07_25_171433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "call_rail_data", force: :cascade do |t|
    t.boolean "answered"
    t.string "business_phone_number"
    t.string "customer_city"
    t.string "customer_country"
    t.string "customer_name"
    t.string "customer_phone_number"
    t.string "customer_state"
    t.string "direction"
    t.integer "duration"
    t.string "call_id"
    t.string "recording"
    t.integer "recording_duration"
    t.string "recording_player"
    t.datetime "start_time"
    t.string "tracking_phone_number"
    t.boolean "voicemail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_id"
  end

  create_table "gravity_form_entries", force: :cascade do |t|
    t.string "company_id"
    t.string "form_id"
    t.string "entry_id"
    t.datetime "date_created"
    t.string "name"
    t.string "phone"
    t.string "email"
    t.text "message"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
