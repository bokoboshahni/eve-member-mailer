# frozen_string_literal: true

class CreateSeries < ActiveRecord::Migration[6.1]
  def change
    create_table :deliveries do |t|
      t.references :recipient, foreign_key: { to_table: :characters }
      t.references :sender, foreign_key: { to_table: :characters }

      t.datetime :delivered_at
      t.datetime :failed_at
      t.integer :evemail_id
      t.text :body
      t.text :kind, null: false, index: true
      t.datetime :scheduled_for
      t.text :status, null: false, index: true
      t.text :subject
      t.uuid :uuid, null: false
      t.timestamps null: false

      t.index :uuid, unique: true, name: :index_unique_delivery_uuid
    end

    create_table :series do |t|
      t.references :corporation, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.time :default_delivery_time
      t.text :description
      t.datetime :discarded_at, index: true
      t.text :name, null: false
      t.datetime :started_at
      t.datetime :stopped_at
      t.text :status, null: false, index: true
      t.timestamps null: false

      t.index %i[corporation_id name], unique: true, name: :index_unique_series_names
    end

    create_table :series_subscriptions do |t|
      t.references :series, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.text :entry_reason
      t.datetime :entered_at
      t.text :exit_reason
      t.datetime :exited_at
      t.text :status, null: false
      t.timestamps null: false

      t.index %i[series_id character_id], unique: true, name: :index_unique_series_subscriptions
      t.index %i[series_id status]
      t.index %i[series_id entered_at]
      t.index %i[series_id exited_at]
    end

    create_table :series_steps do |t|
      t.references :series, null: false, foreign_key: true
      t.references :authorization, foreign_key: true

      t.text :body
      t.integer :delay
      t.time :deliver_at
      t.datetime :discarded_at, index: true
      t.text :kind, null: false
      t.integer :position, null: false
      t.text :status, null: false
      t.text :subject
      t.timestamps null: false

      t.index %i[series_id position], unique: true, name: :index_unique_series_step_positions
    end

    create_table :progressions do |t|
      t.references :series, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.datetime :paused_at
      t.datetime :started_at
      t.text :status, null: false
      t.timestamps null: false

      t.index %i[series_id character_id], unique: true, name: :index_unique_progressions
    end

    create_table :progression_events do |t|
      t.references :progression, null: false
      t.references :step, null: false, foreign_key: { to_table: :series_steps }
      t.references :delivery, foreign_key: true

      t.datetime :completed_at
      t.integer :position, null: false
      t.datetime :scheduled_for
      t.text :status, null: false, index: true
      t.timestamps null: false

      t.index %i[progression_id step_id], unique: true, name: :index_unique_progression_events
    end
  end
end
