# frozen_string_literal: true

class CreateBatchStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :batch_statuses do |t|
      t.references :subject, polymorphic: true

      t.datetime :completed_at
      t.integer :failures
      t.jsonb :failure_info
      t.text :kind, null: false
      t.integer :jobs
      t.text :status, null: false
      t.timestamps null: false
    end
  end
end
