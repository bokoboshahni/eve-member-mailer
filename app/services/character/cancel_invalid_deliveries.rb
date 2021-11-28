# frozen_string_literal: true

class Character < ApplicationRecord
  class CancelInvalidDeliveries < CharacterService
    def call
      logger.info("Canceling invalid deliveries for character \"#{character_name}\" (#{character_id})")
    end
  end
end
