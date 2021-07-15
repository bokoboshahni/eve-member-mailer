# frozen_string_literal: true

# Creates the templates table.
class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.text :description
      t.datetime :discarded_at
      t.text :name, null: false
      t.text :subject, default: '', null: false
      t.text :body, default: '', null: false
      t.text :slug, null: false
      t.text :validation_status
      t.jsonb :validation_data
      t.uuid :uuid, null: false
      t.timestamps null: false

      t.index :discarded_at
      t.index :slug, unique: true, name: :index_unique_template_slugs
    end
  end
end
