# frozen_string_literal: true

# Create broadcast tables.
class CreateBroadcasts < ActiveRecord::Migration[6.1]
  def change
    create_table :broadcasts do |t|
      t.references :alliance, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :corporation, foreign_key: true
      t.references :list, foreign_key: true

      t.text :audience, null: false
      t.text :body
      t.datetime :discarded_at
      t.text :name, null: false
      t.datetime :scheduled_for
      t.text :slug, null: false
      t.text :status, null: false
      t.jsonb :status_data
      t.text :subject
      t.text :validation_status
      t.jsonb :validation_data
      t.timestamps null: false

      t.index :discarded_at
      t.index :status
      t.index :slug, unique: true, name: :index_unique_broadcast_slugs
    end
  end
end
