# frozen_string_literal: true

# Authorization policy for journey steps.
class JourneyStepPolicy < ApplicationPolicy
  # Authorization policy scope for journey steps.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
