# frozen_string_literal: true

# AUthorization policy for corporations.
class CorporationPolicy < ApplicationPolicy
  # Scope for corporation authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
