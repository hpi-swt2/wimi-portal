# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171102084616) do

  create_table "chair_wimis", force: :cascade do |t|
    t.boolean "admin",          default: false
    t.boolean "representative", default: false
    t.string  "application"
    t.integer "user_id"
    t.integer "chair_id"
  end

  add_index "chair_wimis", ["chair_id"], name: "index_chair_wimis_on_chair_id"
  add_index "chair_wimis", ["user_id"], name: "index_chair_wimis_on_user_id"

  create_table "chairs", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.integer "chair_id"
    t.integer "user_id"
    t.integer "hiwi_id"
    t.integer "responsible_id"
    t.boolean "flexible"
    t.integer "hours_per_week"
    t.decimal "wage_per_hour",  precision: 5, scale: 2
    t.text    "description"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.integer  "type"
  end

  add_index "events", ["object_type", "object_id"], name: "index_events_on_object_type_and_object_id"
  add_index "events", ["target_user_id"], name: "index_events_on_target_user_id"
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "expense_items", force: :cascade do |t|
    t.date     "date"
    t.boolean  "breakfast"
    t.boolean  "lunch"
    t.boolean  "dinner"
    t.integer  "expense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "annotation"
  end

  add_index "expense_items", ["expense_id"], name: "index_expense_items_on_expense_id"

  create_table "expenses", force: :cascade do |t|
    t.boolean  "inland"
    t.string   "country"
    t.string   "location_from"
    t.string   "location_via"
    t.text     "reason"
    t.boolean  "car"
    t.boolean  "public_transport"
    t.boolean  "vehicle_advance"
    t.boolean  "hotel"
    t.integer  "status",            default: 0
    t.integer  "general_advance"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "signature"
    t.integer  "trip_id"
    t.string   "time_start"
    t.string   "time_end"
    t.text     "user_signature"
    t.date     "user_signed_at"
    t.text     "rejection_message"
  end

  add_index "expenses", ["trip_id"], name: "index_expenses_on_trip_id"
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id"

  create_table "holidays", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.date     "start"
    t.date     "end"
    t.integer  "status",                   default: 0, null: false
    t.integer  "replacement_user_id"
    t.integer  "length"
    t.boolean  "signature"
    t.date     "last_modified"
    t.string   "reason"
    t.string   "annotation"
    t.integer  "length_last_year",         default: 0
    t.text     "user_signature"
    t.text     "representative_signature"
    t.date     "user_signed_at"
    t.date     "representative_signed_at"
  end

  add_index "holidays", ["user_id"], name: "index_holidays_on_user_id"

  create_table "project_applications", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "description",    default: ""
    t.boolean  "status",         default: true
    t.integer  "chair_id"
    t.string   "project_leader", default: ""
  end

  add_index "projects", ["chair_id"], name: "index_projects_on_chair_id"

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id"

  create_table "time_sheets", force: :cascade do |t|
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "handed_in",                default: false
    t.text     "rejection_message",        default: ""
    t.boolean  "signed",                   default: false
    t.date     "last_modified"
    t.integer  "status",                   default: 0
    t.integer  "signer"
    t.boolean  "wimi_signed",              default: false
    t.date     "hand_in_date"
    t.text     "user_signature"
    t.text     "representative_signature"
    t.date     "user_signed_at"
    t.date     "representative_signed_at"
    t.integer  "contract_id",                              null: false
  end

  add_index "time_sheets", ["contract_id"], name: "index_time_sheets_on_contract_id"

  create_table "trips", force: :cascade do |t|
    t.string   "destination"
    t.text     "reason"
    t.text     "annotation"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "status",                   default: 0
    t.boolean  "signature"
    t.integer  "person_in_power_id"
    t.date     "last_modified"
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "days_abroad"
    t.text     "user_signature"
    t.text     "representative_signature"
    t.date     "user_signed_at"
    t.date     "representative_signed_at"
    t.text     "rejection_message",        default: ""
  end

  add_index "trips", ["person_in_power_id"], name: "index_trips_on_person_in_power_id"
  add_index "trips", ["user_id"], name: "index_trips_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: "",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "identity_url"
    t.string   "language",                  default: "en",  null: false
    t.integer  "personnel_number"
    t.integer  "remaining_leave",           default: 28
    t.integer  "remaining_leave_last_year", default: 0
    t.boolean  "superadmin",                default: false
    t.string   "username"
    t.string   "encrypted_password",        default: "",    null: false
    t.text     "signature"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "event_settings"
    t.integer  "include_comments",          default: 2
  end

  create_table "work_days", force: :cascade do |t|
    t.date     "date"
    t.time     "start_time"
    t.integer  "break"
    t.time     "end_time"
    t.string   "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "time_sheet_id"
    t.integer  "project_id"
    t.string   "status"
  end

  add_index "work_days", ["project_id"], name: "index_work_days_on_project_id"
  add_index "work_days", ["time_sheet_id"], name: "index_work_days_on_time_sheet_id"

end
