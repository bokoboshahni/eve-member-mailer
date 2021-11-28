# frozen_string_literal: true

class CreateAudits < ActiveRecord::Migration[6.1]
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true
      t.references :associated, polymorphic: true
      t.references :user, polymorphic: true

      t.text :username
      t.text :action
      t.jsonb :audited_changes
      t.integer :version, default: 0
      t.text :comment
      t.inet :remote_address
      t.uuid :request_uuid
      t.datetime :created_at

      t.index :request_uuid
      t.index :created_at
    end
  end
end
