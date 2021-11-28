# frozen_string_literal: true

class Authorization < ApplicationRecord
  class AuthorizationService < ApplicationService
    def initialize(authorization)
      super

      @authorization = authorization
    end

    def call; end

    private

    attr_reader :authorization
  end
end
