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

ActiveRecord::Schema.define(version: 2021_09_15_041846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "icon_url_128"
    t.text "icon_url_64"
    t.text "name", null: false
    t.text "ticker", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discarded_at"], name: "index_alliances_on_discarded_at"
  end

  create_table "audits", force: :cascade do |t|
    t.string "auditable_type"
    t.bigint "auditable_id"
    t.string "associated_type"
    t.bigint "associated_id"
    t.string "user_type"
    t.bigint "user_id"
    t.text "username"
    t.text "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.text "comment"
    t.inet "remote_address"
    t.uuid "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "index_audits_on_associated"
    t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_type", "user_id"], name: "index_audits_on_user"
  end

  create_table "authorizations", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.text "access_token_ciphertext", null: false
    t.datetime "expires_at", null: false
    t.text "refresh_token_ciphertext", null: false
    t.text "scopes", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_authorizations_on_character_id"
  end

  create_table "batch_statuses", force: :cascade do |t|
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "completed_at"
    t.integer "failures"
    t.jsonb "failure_info"
    t.text "kind", null: false
    t.integer "jobs"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_type", "subject_id"], name: "index_batch_statuses_on_subject"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "alliance_id"
    t.bigint "corporation_id", null: false
    t.integer "ancestry_id"
    t.date "birthday", null: false
    t.integer "bloodline_id", null: false
    t.text "corporation_roles", default: [], null: false, array: true
    t.date "corporation_start_date"
    t.text "description"
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "gender", null: false
    t.text "name", null: false
    t.text "portrait_url_128"
    t.text "portrait_url_256"
    t.text "portrait_url_512"
    t.text "portrait_url_64"
    t.integer "race_id", null: false
    t.decimal "security_status"
    t.text "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_characters_on_alliance_id"
    t.index ["corporation_id"], name: "index_characters_on_corporation_id"
    t.index ["discarded_at"], name: "index_characters_on_discarded_at"
  end

  create_table "corporation_authorizations", force: :cascade do |t|
    t.bigint "authorization_id", null: false
    t.bigint "corporation_id", null: false
    t.boolean "primary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authorization_id"], name: "index_corporation_authorizations_on_authorization_id"
    t.index ["corporation_id"], name: "index_corporation_authorizations_on_corporation_id"
  end

  create_table "corporations", force: :cascade do |t|
    t.bigint "alliance_id"
    t.text "description"
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "icon_url_128"
    t.text "icon_url_256"
    t.text "icon_url_64"
    t.text "name", null: false
    t.text "ticker", null: false
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_corporations_on_alliance_id"
    t.index ["discarded_at"], name: "index_corporations_on_discarded_at"
  end

  create_table "deliveries", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "sender_id"
    t.datetime "delivered_at"
    t.datetime "failed_at"
    t.integer "evemail_id"
    t.text "body"
    t.text "kind", null: false
    t.datetime "scheduled_for"
    t.text "status", null: false
    t.text "subject"
    t.uuid "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kind"], name: "index_deliveries_on_kind"
    t.index ["recipient_id"], name: "index_deliveries_on_recipient_id"
    t.index ["sender_id"], name: "index_deliveries_on_sender_id"
    t.index ["status"], name: "index_deliveries_on_status"
    t.index ["uuid"], name: "index_unique_delivery_uuid", unique: true
  end

  create_table "login_activities", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.text "scope"
    t.text "strategy"
    t.text "identity_ciphertext"
    t.text "identity_bidx"
    t.boolean "success"
    t.text "failure_reason"
    t.text "context"
    t.text "ip_ciphertext"
    t.text "ip_bidx"
    t.text "user_agent"
    t.text "referrer"
    t.text "city"
    t.text "region"
    t.text "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.index ["identity_bidx"], name: "index_login_activities_on_identity_bidx"
    t.index ["ip_bidx"], name: "index_login_activities_on_ip_bidx"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user"
  end

  create_table "notable_jobs", force: :cascade do |t|
    t.text "note_type"
    t.text "note"
    t.text "job"
    t.text "job_id"
    t.text "queue"
    t.float "runtime"
    t.float "queued_time"
    t.datetime "created_at"
  end

  create_table "notable_requests", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.text "note_type"
    t.text "note"
    t.text "action"
    t.integer "status"
    t.text "url"
    t.text "request_id"
    t.inet "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "params"
    t.float "request_time"
    t.datetime "created_at"
    t.index ["user_type", "user_id"], name: "index_notable_requests_on_user"
  end

  create_table "progression_events", force: :cascade do |t|
    t.bigint "progression_id", null: false
    t.bigint "step_id", null: false
    t.bigint "delivery_id"
    t.datetime "completed_at"
    t.integer "position", null: false
    t.datetime "scheduled_for"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["delivery_id"], name: "index_progression_events_on_delivery_id"
    t.index ["progression_id", "step_id"], name: "index_unique_progression_events", unique: true
    t.index ["progression_id"], name: "index_progression_events_on_progression_id"
    t.index ["status"], name: "index_progression_events_on_status"
    t.index ["step_id"], name: "index_progression_events_on_step_id"
  end

  create_table "progressions", force: :cascade do |t|
    t.bigint "series_id", null: false
    t.bigint "character_id", null: false
    t.datetime "paused_at"
    t.datetime "started_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_progressions_on_character_id"
    t.index ["series_id", "character_id"], name: "index_unique_progressions", unique: true
    t.index ["series_id"], name: "index_progressions_on_series_id"
  end

  create_table "series", force: :cascade do |t|
    t.bigint "corporation_id", null: false
    t.bigint "owner_id", null: false
    t.time "default_delivery_time"
    t.text "description"
    t.datetime "discarded_at"
    t.text "name", null: false
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["corporation_id", "name"], name: "index_unique_series_names", unique: true
    t.index ["corporation_id"], name: "index_series_on_corporation_id"
    t.index ["discarded_at"], name: "index_series_on_discarded_at"
    t.index ["owner_id"], name: "index_series_on_owner_id"
    t.index ["status"], name: "index_series_on_status"
  end

  create_table "series_steps", force: :cascade do |t|
    t.bigint "series_id", null: false
    t.bigint "authorization_id"
    t.text "body"
    t.integer "delay"
    t.time "deliver_at"
    t.datetime "discarded_at"
    t.text "kind", null: false
    t.integer "position", null: false
    t.text "status", null: false
    t.text "subject"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authorization_id"], name: "index_series_steps_on_authorization_id"
    t.index ["discarded_at"], name: "index_series_steps_on_discarded_at"
    t.index ["series_id", "position"], name: "index_unique_series_step_positions", unique: true
    t.index ["series_id"], name: "index_series_steps_on_series_id"
  end

  create_table "series_subscriptions", force: :cascade do |t|
    t.bigint "series_id", null: false
    t.bigint "character_id", null: false
    t.text "entry_reason"
    t.datetime "entered_at"
    t.text "exit_reason"
    t.datetime "exited_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_series_subscriptions_on_character_id"
    t.index ["series_id", "character_id"], name: "index_unique_series_subscriptions", unique: true
    t.index ["series_id", "entered_at"], name: "index_series_subscriptions_on_series_id_and_entered_at"
    t.index ["series_id", "exited_at"], name: "index_series_subscriptions_on_series_id_and_exited_at"
    t.index ["series_id", "status"], name: "index_series_subscriptions_on_series_id_and_status"
    t.index ["series_id"], name: "index_series_subscriptions_on_series_id"
  end

  create_table "user_characters", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "user_id", null: false
    t.boolean "main", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id", "main"], name: "index_unique_user_character_mains", unique: true
    t.index ["character_id"], name: "index_unique_user_characters", unique: true
    t.index ["character_id"], name: "index_user_characters_on_character_id"
    t.index ["user_id"], name: "index_user_characters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "authorizations", "characters"
  add_foreign_key "characters", "alliances"
  add_foreign_key "characters", "corporations"
  add_foreign_key "corporation_authorizations", "authorizations"
  add_foreign_key "corporation_authorizations", "corporations"
  add_foreign_key "corporations", "alliances"
  add_foreign_key "deliveries", "characters", column: "recipient_id"
  add_foreign_key "deliveries", "characters", column: "sender_id"
  add_foreign_key "progression_events", "deliveries"
  add_foreign_key "progression_events", "series_steps", column: "step_id"
  add_foreign_key "progressions", "characters"
  add_foreign_key "progressions", "series"
  add_foreign_key "series", "corporations"
  add_foreign_key "series", "users", column: "owner_id"
  add_foreign_key "series_steps", "authorizations"
  add_foreign_key "series_steps", "series"
  add_foreign_key "series_subscriptions", "characters"
  add_foreign_key "series_subscriptions", "series"
  add_foreign_key "user_characters", "characters"
  add_foreign_key "user_characters", "users"
end
