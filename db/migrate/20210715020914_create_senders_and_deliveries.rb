# frozen_string_literal: true

# Create the senders and deliveries tables.
class CreateSendersAndDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :senders do |t|
      t.references :broadcast, foreign_key: true
      t.references :campaign, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps null: false

      t.index %i[character_id broadcast_id], unique: true, name: :index_unique_sender_broadcast_characters
      t.index %i[character_id campaign_id], unique: true, name: :index_unique_sender_campaign_characters
    end

    create_table :deliveries do |t|
      t.references :broadcast, foreign_key: true
      t.references :campaign_step, foreign_key: true
      t.references :alliance, foreign_key: true
      t.references :character, foreign_key: true
      t.references :corporation, foreign_key: true
      t.references :authorization, foreign_key: true
      t.references :template, foreign_key: true

      t.datetime :attempted_at
      t.datetime :delivered_at
      t.datetime :failed_at
      t.integer :evemail_id
      t.text :body
      t.text :kind, null: false
      t.datetime :queued_at
      t.datetime :scheduled_for
      t.text :status, null: false
      t.jsonb :status_data
      t.text :subject
      t.uuid :uuid, null: false
      t.timestamps null: false

      t.index :status
      t.index :uuid, unique: true, name: :index_unique_delivery_uuid
      t.index %i[broadcast_id alliance_id], unique: true, name: :index_unique_delivery_broadcast_alliances
      t.index %i[broadcast_id corporation_id], unique: true, name: :index_unique_delivery_broadcast_corporations
      t.index %i[broadcast_id character_id], unique: true, name: :index_unique_delivery_broadcast_characters
      t.index %i[campaign_step_id character_id], unique: true, name: :index_unique_delivery_campaign_steps
    end
  end
end
