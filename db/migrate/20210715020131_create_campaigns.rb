# frozen_string_literal: true

# Create campaign tables.
class CreateCampaigns < ActiveRecord::Migration[6.1]
  def change
    create_table :campaigns do |t|
      t.references :corporation, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.time :default_delivery_time
      t.text :description
      t.datetime :discarded_at
      t.text :kind, null: false
      t.text :name, null: false
      t.text :slug, null: false
      t.datetime :started_at
      t.datetime :stopped_at
      t.text :status, null: false
      t.jsonb :status_data
      t.text :qualifier, null: false
      t.text :validation_status
      t.jsonb :validation_data
      t.timestamps null: false

      t.index :discarded_at
      t.index :kind
      t.index :status
      t.index :slug, unique: true, name: :index_unique_campaign_slugs
    end

    create_table :campaign_filters do |t|
      t.references :campaign, foreign_key: true

      t.text :ancestry
      t.datetime :discarded_at
      t.text :kind, null: false
      t.text :condition
      t.text :operator
      t.text :qualifier
      t.text :subject
      t.text :value
      t.text :value_from
      t.text :value_to
      t.text :value_prefix
      t.text :value_suffix
      t.integer :position, null: false
      t.timestamps null: false

      t.index :ancestry
      t.index :discarded_at
      t.index %i[campaign_id ancestry position], unique: true, name: :index_unique_campaign_filter_positions
    end

    create_table :campaign_memberships do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.text :entry_reason
      t.datetime :entered_at
      t.text :exit_reason
      t.datetime :exited_at
      t.text :status, null: false
      t.timestamps null: false

      t.index %i[campaign_id character_id], unique: true, name: :index_unique_campaign_characters
      t.index %i[campaign_id status]
      t.index %i[campaign_id entered_at]
      t.index %i[campaign_id exited_at]
    end

    create_table :campaign_steps do |t|
      t.references :campaign, null: false, foreign_key: true

      t.text :body
      t.integer :delay
      t.time :delivery_time
      t.text :kind, null: false
      t.integer :position, null: false
      t.text :status, null: false
      t.text :subject
      t.text :validation_status
      t.jsonb :validation_data
      t.timestamps null: false

      t.index %i[campaign_id position], unique: true, name: :index_unique_campaign_step_positions
    end

    create_table :campaign_triggers do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :list, foreign_key: true

      t.text :kind, null: false
      t.text :qualifier
      t.integer :date_attribute
      t.integer :date_day
      t.integer :date_month
      t.integer :date_year
      t.integer :date_window
      t.timestamps null: false

      t.index %i[campaign_id list_id], unique: true, name: :index_unique_campaign_trigger_lists
    end
  end
end
