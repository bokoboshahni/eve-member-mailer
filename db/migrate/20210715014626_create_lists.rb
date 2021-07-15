# frozen_string_literal: true

# Creates tables for lists.
class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, null: false
      t.references :user, foreign_key: true

      t.datetime :created_at, null: false
      t.text :event, null: false
      t.jsonb :object
      t.jsonb :object_changes

      t.index %i[item_id item_type created_at]
      t.index %i[item_id item_type user_id]
      t.index %i[item_type user_id]
    end

    create_table :lists do |t|
      t.references :corporation, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.text :qualifier, null: false
      t.text :description
      t.datetime :discarded_at
      t.text :kind, null: false
      t.text :name, null: false
      t.text :slug, null: false
      t.text :status, null: false
      t.jsonb :status_data
      t.timestamps null: false

      t.index :discarded_at
      t.index :slug, unique: true, name: :index_unique_list_slug
      t.index :status
    end

    create_table :list_conditions do |t|
      t.references :alliance, foreign_key: true
      t.references :corporation, foreign_key: true
      t.references :list, foreign_key: true

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
      t.index %i[list_id ancestry position], unique: true, name: :index_unique_list_condition_positions
    end

    create_table :list_memberships do |t|
      t.references :list, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.datetime :discarded_at
      t.datetime :entered_at
      t.text :entry_reason
      t.datetime :exited_at
      t.text :exit_reason
      t.text :status, null: false
      t.jsonb :status_data
      t.timestamps null: false

      t.index :discarded_at
      t.index %i[list_id character_id], unique: true, name: :index_unique_list_characters
      t.index %i[list_id character_id status], name: :index_list_character_statuses
      t.index %i[list_id entered_at]
      t.index %i[list_id exited_at]
    end
  end
end
