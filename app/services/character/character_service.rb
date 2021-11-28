# frozen_string_literal: true

class Character < ApplicationRecord
  class CharacterService < ApplicationService
    def initialize(character)
      super

      @character = character
    end

    def call; end

    private

    attr_reader :character

    delegate :id, :name, to: :character, prefix: true
  end
end
