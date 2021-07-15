# frozen_string_literal: true

# Authorization policy for lists.
class ListPolicy < ApplicationPolicy
  # Scope for list authorization policy.
  class Scope < Scope
    def resolve
      scope.kept
    end
  end
end
