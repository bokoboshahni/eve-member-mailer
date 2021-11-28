# frozen_string_literal: true

class CreateAuthTables < ActiveRecord::Migration[6.1] # rubocop:disable Metrics/ClassLength
  def change
    enable_extension 'pgcrypto'

    create_table :notable_jobs do |t|
      t.text :note_type
      t.text :note
      t.text :job
      t.text :job_id
      t.text :queue
      t.float :runtime
      t.float :queued_time
      t.datetime :created_at
    end

    create_table :notable_requests do |t|
      t.references :user, polymorphic: true

      t.text :note_type
      t.text :note
      t.text :action
      t.integer :status
      t.text :url
      t.text :request_id
      t.inet :ip
      t.text :user_agent
      t.text :referrer
      t.text :params
      t.float :request_time
      t.datetime :created_at
    end

    create_table :alliances do |t|
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :icon_url_128 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_64 # rubocop:disable Naming/VariableNumber
      t.text :name, null: false
      t.text :ticker, null: false
      t.timestamps null: false

      t.index :discarded_at
    end

    create_table :corporations do |t|
      t.references :alliance, foreign_key: true

      t.text :description
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :icon_url_128 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_256 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_64 # rubocop:disable Naming/VariableNumber
      t.text :name, null: false
      t.text :ticker, null: false
      t.text :url
      t.timestamps null: false

      t.index :discarded_at
    end

    create_table :characters do |t|
      t.references :alliance, foreign_key: true
      t.references :corporation, null: false, foreign_key: true

      t.integer :ancestry_id
      t.date :birthday, null: false
      t.integer :bloodline_id, null: false
      t.text :corporation_roles, array: true, null: false, default: []
      t.date :corporation_start_date
      t.text :description
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :gender, null: false
      t.text :name, null: false
      t.text :portrait_url_128 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_256 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_512 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_64 # rubocop:disable Naming/VariableNumber
      t.integer :race_id, null: false
      t.decimal :security_status
      t.text :title
      t.timestamps null: false

      t.index :discarded_at
    end

    create_table :users do |t|
      t.boolean :admin
      t.timestamps null: false
    end

    create_table :user_characters do |t|
      t.references :character, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.boolean :main, null: false, default: false
      t.timestamps null: false

      t.index %i[character_id], unique: true, name: :index_unique_user_characters
      t.index %i[character_id main], unique: true, name: :index_unique_user_character_mains
    end

    create_table :login_activities do |t|
      t.references :user, polymorphic: true

      t.text :scope
      t.text :strategy
      t.text :identity_ciphertext
      t.text :identity_bidx, index: true
      t.boolean :success
      t.text :failure_reason
      t.text :context
      t.text :ip_ciphertext
      t.text :ip_bidx, index: true
      t.text :user_agent
      t.text :referrer
      t.text :city
      t.text :region
      t.text :country
      t.float :latitude
      t.float :longitude
      t.datetime :created_at
    end

    create_table :authorizations do |t|
      t.references :character, null: false, foreign_key: true

      t.text :access_token_ciphertext, null: false
      t.datetime :expires_at, null: false
      t.text :refresh_token_ciphertext, null: false
      t.text :scopes, array: true, null: false, default: []
      t.timestamps null: false
    end
  end
end
