# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncCorporationMembership < CharacterService
    def call
      ActiveRecord::Base.transaction do
        Character::RemoveInvalidStepAuthorizations.call(character)
        Character::CancelInvalidDeliveries.call(character)
        Character::ExitSeries.call(character)
        Character::EnterSeries.call(character)
      end
      logger.info("Synced corporation membership for character \"#{character_name}\" (#{character_id})")
    end
  end
end
