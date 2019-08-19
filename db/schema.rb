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

ActiveRecord::Schema.define(version: 2019_08_15_050354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link"], name: "index_pull_requests_on_link"
    t.index ["user_id"], name: "index_pull_requests_on_user_id"
  end

  create_table "pull_requests_tagged_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "pull_request_id"
    t.string "status", default: "active"
    t.string "string", default: "active"
    t.index ["pull_request_id"], name: "index_pull_requests_tagged_users_on_pull_request_id"
    t.index ["status"], name: "index_pull_requests_tagged_users_on_status"
    t.index ["string"], name: "index_pull_requests_tagged_users_on_string"
    t.index ["user_id"], name: "index_pull_requests_tagged_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "slack_scopes", default: [], array: true
    t.string "slack_id"
    t.string "slack_team_id"
    t.string "slack_access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id"
  end

  add_foreign_key "pull_requests", "users"
  add_foreign_key "pull_requests_tagged_users", "pull_requests"
  add_foreign_key "pull_requests_tagged_users", "users"
end
