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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20160109205725) do
=======
ActiveRecord::Schema.define(version: 20151215185150) do
>>>>>>> origin/dev

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

  create_table "expenses", force: :cascade do |t|
    t.decimal  "amount"
    t.text     "purpose"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "trip_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  add_index "expenses", ["project_id"], name: "index_expenses_on_project_id"
  add_index "expenses", ["trip_id"], name: "index_expenses_on_trip_id"
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id"

  create_table "holidays", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.date     "start"
    t.date     "end"
    t.integer  "status",     default: 0
  end

  add_index "holidays", ["user_id"], name: "index_holidays_on_user_id"

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.boolean  "public",         default: true
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

  create_table "publications", force: :cascade do |t|
    t.string   "title"
    t.string   "venue"
    t.string   "type_"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "publications", ["project_id"], name: "index_publications_on_project_id"

  create_table "publications_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "publication_id"
  end

  add_index "publications_users", ["publication_id"], name: "index_publications_users_on_publication_id"
  add_index "publications_users", ["user_id"], name: "index_publications_users_on_user_id"

  create_table "time_sheets", force: :cascade do |t|
    t.integer  "month"
    t.integer  "year"
    t.integer  "salary"
    t.boolean  "salary_is_per_month"
    t.integer  "workload"
    t.boolean  "workload_is_per_month"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "handed_in",             default: false
    t.text     "rejection_message",     default: ""
    t.boolean  "signed",                default: false
    t.date     "last_modified"
    t.integer  "status",                default: 0
    t.integer  "signer"
  end

  create_table "travel_expense_report_items", force: :cascade do |t|
    t.date     "date"
    t.boolean  "breakfast"
    t.boolean  "lunch"
    t.boolean  "dinner"
    t.integer  "travel_expense_report_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "annotation"
  end

  add_index "travel_expense_report_items", ["travel_expense_report_id"], name: "index_travel_expense_report_items_on_travel_expense_report_id"

  create_table "travel_expense_reports", force: :cascade do |t|
    t.boolean  "inland"
    t.string   "country"
    t.string   "location_from"
    t.string   "location_via"
    t.string   "location_to"
    t.text     "reason"
    t.datetime "date_start"
    t.datetime "date_end"
    t.boolean  "car"
    t.boolean  "public_transport"
    t.boolean  "vehicle_advance"
    t.boolean  "hotel"
    t.integer  "general_advance"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "signature"
  end

  add_index "travel_expense_reports", ["user_id"], name: "index_travel_expense_reports_on_user_id"

  create_table "trip_datespans", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "days_abroad"
    t.integer  "trip_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "trip_datespans", ["trip_id"], name: "index_trip_datespans_on_trip_id"

  create_table "trips", force: :cascade do |t|
    t.string   "destination"
    t.text     "reason"
    t.text     "annotation"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0
    t.boolean  "signature"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: "",    null: false
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "identity_url"
    t.string   "language",                  default: "en",  null: false
    t.string   "residence"
    t.string   "street"
    t.integer  "personnel_number",          default: 0
    t.integer  "remaining_leave",           default: 28
    t.integer  "remaining_leave_last_year", default: 0
    t.boolean  "superadmin",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "work_days", force: :cascade do |t|
    t.date     "date"
    t.time     "start_time"
    t.integer  "break"
    t.time     "end_time"
    t.string   "attendance"
    t.string   "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "project_id"
  end

end
