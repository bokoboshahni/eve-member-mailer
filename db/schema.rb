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

ActiveRecord::Schema.define(version: 2021_07_15_021016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discarded_at"], name: "index_alliances_on_discarded_at"
  end

  create_table "authorizations", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.text "access_token_ciphertext", null: false
    t.datetime "expires_at", null: false
    t.text "refresh_token_ciphertext", null: false
    t.text "kind", null: false
    t.text "scopes", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id", "kind"], name: "index_unique_authorizations", unique: true
    t.index ["character_id"], name: "index_authorizations_on_character_id"
    t.index ["kind"], name: "index_authorizations_on_kind"
  end

  create_table "broadcasts", force: :cascade do |t|
    t.bigint "alliance_id"
    t.bigint "owner_id", null: false
    t.bigint "corporation_id"
    t.bigint "list_id"
    t.text "audience", null: false
    t.text "body"
    t.datetime "discarded_at"
    t.text "name", null: false
    t.datetime "scheduled_for"
    t.text "slug", null: false
    t.text "status", null: false
    t.jsonb "status_data"
    t.text "subject"
    t.text "validation_status"
    t.jsonb "validation_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_broadcasts_on_alliance_id"
    t.index ["corporation_id"], name: "index_broadcasts_on_corporation_id"
    t.index ["discarded_at"], name: "index_broadcasts_on_discarded_at"
    t.index ["list_id"], name: "index_broadcasts_on_list_id"
    t.index ["owner_id"], name: "index_broadcasts_on_owner_id"
    t.index ["slug"], name: "index_unique_broadcast_slugs", unique: true
    t.index ["status"], name: "index_broadcasts_on_status"
  end

  create_table "campaign_filters", force: :cascade do |t|
    t.bigint "campaign_id"
    t.text "ancestry"
    t.datetime "discarded_at"
    t.text "kind", null: false
    t.text "condition"
    t.text "operator"
    t.text "qualifier"
    t.text "subject"
    t.text "value"
    t.text "value_from"
    t.text "value_to"
    t.text "value_prefix"
    t.text "value_suffix"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_campaign_filters_on_ancestry"
    t.index ["campaign_id", "ancestry", "position"], name: "index_unique_campaign_filter_positions", unique: true
    t.index ["campaign_id"], name: "index_campaign_filters_on_campaign_id"
    t.index ["discarded_at"], name: "index_campaign_filters_on_discarded_at"
  end

  create_table "campaign_memberships", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "character_id", null: false
    t.text "entry_reason"
    t.datetime "entered_at"
    t.text "exit_reason"
    t.datetime "exited_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id", "character_id"], name: "index_unique_campaign_characters", unique: true
    t.index ["campaign_id", "entered_at"], name: "index_campaign_memberships_on_campaign_id_and_entered_at"
    t.index ["campaign_id", "exited_at"], name: "index_campaign_memberships_on_campaign_id_and_exited_at"
    t.index ["campaign_id", "status"], name: "index_campaign_memberships_on_campaign_id_and_status"
    t.index ["campaign_id"], name: "index_campaign_memberships_on_campaign_id"
    t.index ["character_id"], name: "index_campaign_memberships_on_character_id"
  end

  create_table "campaign_steps", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.text "body"
    t.integer "delay"
    t.time "delivery_time"
    t.text "kind", null: false
    t.integer "position", null: false
    t.text "status", null: false
    t.text "subject"
    t.text "validation_status"
    t.jsonb "validation_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id", "position"], name: "index_unique_campaign_step_positions", unique: true
    t.index ["campaign_id"], name: "index_campaign_steps_on_campaign_id"
  end

  create_table "campaign_triggers", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "list_id"
    t.text "kind", null: false
    t.text "qualifier"
    t.integer "date_attribute"
    t.integer "date_day"
    t.integer "date_month"
    t.integer "date_year"
    t.integer "date_window"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id", "list_id"], name: "index_unique_campaign_trigger_lists", unique: true
    t.index ["campaign_id"], name: "index_campaign_triggers_on_campaign_id"
    t.index ["list_id"], name: "index_campaign_triggers_on_list_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "corporation_id", null: false
    t.bigint "owner_id", null: false
    t.time "default_delivery_time"
    t.text "description"
    t.datetime "discarded_at"
    t.text "kind", null: false
    t.text "name", null: false
    t.text "slug", null: false
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.text "status", null: false
    t.jsonb "status_data"
    t.text "qualifier", null: false
    t.text "validation_status"
    t.jsonb "validation_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["corporation_id"], name: "index_campaigns_on_corporation_id"
    t.index ["discarded_at"], name: "index_campaigns_on_discarded_at"
    t.index ["kind"], name: "index_campaigns_on_kind"
    t.index ["owner_id"], name: "index_campaigns_on_owner_id"
    t.index ["slug"], name: "index_unique_campaign_slugs", unique: true
    t.index ["status"], name: "index_campaigns_on_status"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "alliance_id"
    t.bigint "corporation_id", null: false
    t.integer "ancestry_id"
    t.date "birthday", null: false
    t.integer "bloodline_id", null: false
    t.date "corporation_start_date"
    t.text "description"
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "gender", null: false
    t.text "name", null: false
    t.integer "race_id", null: false
    t.decimal "security_status"
    t.text "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_characters_on_alliance_id"
    t.index ["corporation_id"], name: "index_characters_on_corporation_id"
    t.index ["discarded_at"], name: "index_characters_on_discarded_at"
  end

  create_table "corporations", force: :cascade do |t|
    t.bigint "alliance_id"
    t.text "description"
    t.datetime "discarded_at"
    t.integer "faction_id"
    t.text "name", null: false
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_corporations_on_alliance_id"
    t.index ["discarded_at"], name: "index_corporations_on_discarded_at"
  end

  create_table "deliveries", force: :cascade do |t|
    t.bigint "broadcast_id"
    t.bigint "campaign_step_id"
    t.bigint "alliance_id"
    t.bigint "character_id"
    t.bigint "corporation_id"
    t.bigint "authorization_id"
    t.bigint "template_id"
    t.datetime "attempted_at"
    t.datetime "delivered_at"
    t.datetime "failed_at"
    t.integer "evemail_id"
    t.text "body"
    t.text "kind", null: false
    t.datetime "queued_at"
    t.datetime "scheduled_for"
    t.text "status", null: false
    t.jsonb "status_data"
    t.text "subject"
    t.uuid "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_deliveries_on_alliance_id"
    t.index ["authorization_id"], name: "index_deliveries_on_authorization_id"
    t.index ["broadcast_id", "alliance_id"], name: "index_unique_delivery_broadcast_alliances", unique: true
    t.index ["broadcast_id", "character_id"], name: "index_unique_delivery_broadcast_characters", unique: true
    t.index ["broadcast_id", "corporation_id"], name: "index_unique_delivery_broadcast_corporations", unique: true
    t.index ["broadcast_id"], name: "index_deliveries_on_broadcast_id"
    t.index ["campaign_step_id", "character_id"], name: "index_unique_delivery_campaign_steps", unique: true
    t.index ["campaign_step_id"], name: "index_deliveries_on_campaign_step_id"
    t.index ["character_id"], name: "index_deliveries_on_character_id"
    t.index ["corporation_id"], name: "index_deliveries_on_corporation_id"
    t.index ["status"], name: "index_deliveries_on_status"
    t.index ["template_id"], name: "index_deliveries_on_template_id"
    t.index ["uuid"], name: "index_unique_delivery_uuid", unique: true
  end

  create_table "journey_steps", force: :cascade do |t|
    t.bigint "journey_id", null: false
    t.bigint "campaign_step_id", null: false
    t.bigint "delivery_id"
    t.datetime "paused_at"
    t.datetime "scheduled_for"
    t.datetime "started_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_step_id"], name: "index_journey_steps_on_campaign_step_id"
    t.index ["delivery_id"], name: "index_journey_steps_on_delivery_id"
    t.index ["journey_id", "campaign_step_id"], name: "index_unique_journey_campaign_steps", unique: true
    t.index ["journey_id"], name: "index_journey_steps_on_journey_id"
  end

  create_table "journeys", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "character_id", null: false
    t.datetime "paused_at"
    t.datetime "started_at"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id", "character_id"], name: "index_journeys_on_campaign_id_and_character_id"
    t.index ["campaign_id"], name: "index_journeys_on_campaign_id"
    t.index ["character_id"], name: "index_journeys_on_character_id"
  end

  create_table "list_conditions", force: :cascade do |t|
    t.bigint "alliance_id"
    t.bigint "corporation_id"
    t.bigint "list_id"
    t.text "ancestry"
    t.datetime "discarded_at"
    t.text "kind", null: false
    t.text "condition"
    t.text "operator"
    t.text "qualifier"
    t.text "subject"
    t.text "value"
    t.text "value_from"
    t.text "value_to"
    t.text "value_prefix"
    t.text "value_suffix"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_list_conditions_on_alliance_id"
    t.index ["ancestry"], name: "index_list_conditions_on_ancestry"
    t.index ["corporation_id"], name: "index_list_conditions_on_corporation_id"
    t.index ["discarded_at"], name: "index_list_conditions_on_discarded_at"
    t.index ["list_id", "ancestry", "position"], name: "index_unique_list_condition_positions", unique: true
    t.index ["list_id"], name: "index_list_conditions_on_list_id"
  end

  create_table "list_memberships", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.bigint "character_id", null: false
    t.datetime "discarded_at"
    t.datetime "entered_at"
    t.text "entry_reason"
    t.datetime "exited_at"
    t.text "exit_reason"
    t.text "status", null: false
    t.jsonb "status_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_list_memberships_on_character_id"
    t.index ["discarded_at"], name: "index_list_memberships_on_discarded_at"
    t.index ["list_id", "character_id", "status"], name: "index_list_character_statuses"
    t.index ["list_id", "character_id"], name: "index_unique_list_characters", unique: true
    t.index ["list_id", "entered_at"], name: "index_list_memberships_on_list_id_and_entered_at"
    t.index ["list_id", "exited_at"], name: "index_list_memberships_on_list_id_and_exited_at"
    t.index ["list_id"], name: "index_list_memberships_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "corporation_id", null: false
    t.bigint "owner_id", null: false
    t.text "qualifier", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.text "kind", null: false
    t.text "name", null: false
    t.text "slug", null: false
    t.text "status", null: false
    t.jsonb "status_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["corporation_id"], name: "index_lists_on_corporation_id"
    t.index ["discarded_at"], name: "index_lists_on_discarded_at"
    t.index ["owner_id"], name: "index_lists_on_owner_id"
    t.index ["slug"], name: "index_unique_list_slug", unique: true
    t.index ["status"], name: "index_lists_on_status"
  end

  create_table "senders", force: :cascade do |t|
    t.bigint "broadcast_id"
    t.bigint "campaign_id"
    t.bigint "character_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broadcast_id"], name: "index_senders_on_broadcast_id"
    t.index ["campaign_id"], name: "index_senders_on_campaign_id"
    t.index ["character_id", "broadcast_id"], name: "index_unique_sender_broadcast_characters", unique: true
    t.index ["character_id", "campaign_id"], name: "index_unique_sender_campaign_characters", unique: true
    t.index ["character_id"], name: "index_senders_on_character_id"
  end

  create_table "templates", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.text "name", null: false
    t.text "subject", default: "", null: false
    t.text "body", default: "", null: false
    t.text "slug", null: false
    t.text "validation_status"
    t.jsonb "validation_data"
    t.uuid "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discarded_at"], name: "index_templates_on_discarded_at"
    t.index ["owner_id"], name: "index_templates_on_owner_id"
    t.index ["slug"], name: "index_unique_template_slugs", unique: true
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
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.integer "sign_in_count", default: 0, null: false
    t.text "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_unique_user_slugs", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.text "event", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.index ["item_id", "item_type", "created_at"], name: "index_versions_on_item_id_and_item_type_and_created_at"
    t.index ["item_id", "item_type", "user_id"], name: "index_versions_on_item_id_and_item_type_and_user_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item"
    t.index ["item_type", "user_id"], name: "index_versions_on_item_type_and_user_id"
    t.index ["user_id"], name: "index_versions_on_user_id"
  end

  add_foreign_key "authorizations", "characters"
  add_foreign_key "broadcasts", "alliances"
  add_foreign_key "broadcasts", "corporations"
  add_foreign_key "broadcasts", "lists"
  add_foreign_key "broadcasts", "users", column: "owner_id"
  add_foreign_key "campaign_filters", "campaigns"
  add_foreign_key "campaign_memberships", "campaigns"
  add_foreign_key "campaign_memberships", "characters"
  add_foreign_key "campaign_steps", "campaigns"
  add_foreign_key "campaign_triggers", "campaigns"
  add_foreign_key "campaign_triggers", "lists"
  add_foreign_key "campaigns", "corporations"
  add_foreign_key "campaigns", "users", column: "owner_id"
  add_foreign_key "characters", "alliances"
  add_foreign_key "characters", "corporations"
  add_foreign_key "corporations", "alliances"
  add_foreign_key "deliveries", "alliances"
  add_foreign_key "deliveries", "authorizations"
  add_foreign_key "deliveries", "broadcasts"
  add_foreign_key "deliveries", "campaign_steps"
  add_foreign_key "deliveries", "characters"
  add_foreign_key "deliveries", "corporations"
  add_foreign_key "deliveries", "templates"
  add_foreign_key "journey_steps", "campaign_steps"
  add_foreign_key "journey_steps", "deliveries"
  add_foreign_key "journey_steps", "journeys"
  add_foreign_key "journeys", "campaigns"
  add_foreign_key "journeys", "characters"
  add_foreign_key "list_conditions", "alliances"
  add_foreign_key "list_conditions", "corporations"
  add_foreign_key "list_conditions", "lists"
  add_foreign_key "list_memberships", "characters"
  add_foreign_key "list_memberships", "lists"
  add_foreign_key "lists", "corporations"
  add_foreign_key "lists", "users", column: "owner_id"
  add_foreign_key "senders", "broadcasts"
  add_foreign_key "senders", "campaigns"
  add_foreign_key "senders", "characters"
  add_foreign_key "templates", "users", column: "owner_id"
  add_foreign_key "user_characters", "characters"
  add_foreign_key "user_characters", "users"
  add_foreign_key "versions", "users"
end
