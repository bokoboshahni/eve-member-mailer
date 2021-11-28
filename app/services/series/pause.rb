# frozen_string_literal: true

class Series < ApplicationRecord
  class Pause < ApplicationService
    def initialize(series)
      super

      @series = series
    end

    def call; end

    private

    attr_reader :series
  end
end
