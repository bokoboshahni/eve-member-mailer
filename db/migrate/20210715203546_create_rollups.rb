# frozen_string_literal: true

# Creates the rollups table.
class CreateRollups < ActiveRecord::Migration[6.1]
  def change
    create_table :rollups do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :name, null: false
      t.string :interval, null: false
      t.datetime :time, null: false
      t.jsonb :dimensions, null: false, default: {}
      t.float :value
    end
    add_index :rollups, %i[name interval time dimensions], unique: true
  end
end
