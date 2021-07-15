# frozen_string_literal: true

# Create tables for authentication and authorization.
class CreateAuthTables < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pg_stat_statements'
    enable_extension 'pgcrypto'

    create_table :alliances do |t|
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :name, null: false
      t.timestamps null: false

      t.index :discarded_at
    end

    create_table :corporations do |t|
      t.references :alliance, foreign_key: true

      t.text :description
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :name, null: false
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
      t.date :corporation_start_date
      t.text :description
      t.datetime :discarded_at
      t.integer :faction_id
      t.text :gender, null: false
      t.text :name, null: false
      t.integer :race_id, null: false
      t.decimal :security_status
      t.text :title
      t.timestamps null: false

      t.index :discarded_at
    end

    create_table :users do |t|
      t.boolean :admin
      t.datetime :current_sign_in_at
      t.inet :current_sign_in_ip
      t.datetime :last_sign_in_at
      t.inet :last_sign_in_ip
      t.integer :sign_in_count, default: 0, null: false
      t.text :slug, null: false
      t.timestamps null: false

      t.index :slug, unique: true, name: :index_unique_user_slugs
    end

    create_table :user_characters do |t|
      t.references :character, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.boolean :main, null: false, default: false
      t.timestamps null: false

      t.index %i[character_id], unique: true, name: :index_unique_user_characters
      t.index %i[character_id main], unique: true, name: :index_unique_user_character_mains
    end

    create_table :authorizations do |t|
      t.references :character, null: false, foreign_key: true

      t.text :access_token_ciphertext, null: false
      t.datetime :expires_at, null: false
      t.text :refresh_token_ciphertext, null: false
      t.text :kind, null: false
      t.text :scopes, array: true, null: false, default: []
      t.timestamps null: false

      t.index :kind
      t.index %i[character_id kind], unique: true, name: :index_unique_authorizations
    end
  end
end
