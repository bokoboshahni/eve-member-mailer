# frozen_string_literal: true

class Character < ApplicationRecord
  class EnterSeries < ApplicationService
    def initialize(character:, series:)
      super

      @character = character
      @series = series
    end

    def call
      return if character.progressions.exists?(series: series)

      character.progressions.create!(series: series, status: 'active')

      logger.info("Entered series \"#{series_name}\" (#{series_id}) for character \"#{character_name}\" (#{character_id})")
    end

    private

    attr_reader :character, :series

    delegate :id, :name, to: :character, prefix: true
    delegate :id, :name, to: :series, prefix: true
  end
end
