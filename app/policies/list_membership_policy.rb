# frozen_string_literal: true

# Authorization policy for list memberships.
class ListMembershipPolicy < ApplicationPolicy
  # Authorization policy scope for list memberships.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
