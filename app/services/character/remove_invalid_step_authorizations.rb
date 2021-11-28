# frozen_string_literal: true

class Character < ApplicationRecord
  class RemoveInvalidStepAuthorizations < CharacterService
    def call
      logger.info("Removing invalid senders for character \"#{character_name}\" (#{character_id})")
    end
  end
end
