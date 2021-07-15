# frozen_string_literal: true

# Authorization policy for journeys.
class JourneyPolicy < ApplicationPolicy
  # Authorization policy scope for journeys.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
