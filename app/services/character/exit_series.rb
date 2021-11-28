# frozen_string_literal: true

class Character < ApplicationRecord
  class ExitSeries < CharacterService
    def call
      logger.info("Exiting series for character \"#{character_name}\" (#{character_id})")
    end
  end
end
