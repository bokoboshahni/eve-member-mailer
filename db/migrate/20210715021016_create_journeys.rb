# frozen_string_literal: true

# Creates tables for journeys.
class CreateJourneys < ActiveRecord::Migration[6.1]
  def change
    create_table :journeys do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.datetime :paused_at
      t.datetime :started_at
      t.text :status, null: false
      t.timestamps null: false

      t.index %i[campaign_id character_id]
    end

    create_table :journey_steps do |t|
      t.references :journey, null: false, foreign_key: true
      t.references :campaign_step, null: false, foreign_key: true
      t.references :delivery, foreign_key: true

      t.datetime :paused_at
      t.datetime :scheduled_for
      t.datetime :started_at
      t.text :status, null: false
      t.timestamps null: false

      t.index %i[journey_id campaign_step_id], unique: true, name: :index_unique_journey_campaign_steps
    end
  end
end
