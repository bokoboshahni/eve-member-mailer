# frozen_string_literal: true

class CreateCorporationAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :corporation_authorizations do |t|
      t.references :authorization, null: false, foreign_key: true
      t.references :corporation, null: false, foreign_key: true

      t.boolean :primary
      t.timestamps null: false
    end
  end
end
