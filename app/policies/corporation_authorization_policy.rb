# frozen_string_literal: true

class CorporationAuthorizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
