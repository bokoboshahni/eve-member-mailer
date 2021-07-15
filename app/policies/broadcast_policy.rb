# frozen_string_literal: true

# Authorization policy for broadcasts.
class BroadcastPolicy < ApplicationPolicy
  # Scope for authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
