# frozen_string_literal: true

class Corporation < ApplicationRecord
  class CorporationService < ApplicationService
    def initialize(corporation)
      super

      @corporation = corporation
    end

    def call; end

    private

    attr_reader :corporation
  end
end
