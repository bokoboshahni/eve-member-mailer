# frozen_string_literal: true

class Delivery < ApplicationRecord
  class DeliveryService < ApplicationService
    def initialize(delivery)
      super

      @delivery = delivery
    end

    def call; end

    private

    attr_reader :delivery
  end
end
