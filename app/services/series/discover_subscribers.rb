# frozen_string_literal: true

class Series < ApplicationRecord
  class DiscoverSubscribers < ApplicationService
    def initialize(series:, newer_than: nil)
      super

      @series = series
      @newer_than = newer_than
    end

    def call
      matched_characters = if newer_than
                             corporation.characters.where('corporation_start_date > ?', newer_than)
                           else
                             corporation.characters
                           end

      matched_character_ids = matched_characters.pluck(:id)
      subscribed_character_ids = characters.pluck(:id)
      matched_character_ids - subscribed_character_ids
    end

    private

    attr_reader :newer_than, :series

    delegate :corporation, :characters, to: :series
  end
end
