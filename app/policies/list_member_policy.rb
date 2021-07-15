# frozen_string_literal: true

# Authorization policy for list members.
class ListMemberPolicy < ApplicationPolicy
  # Scope for list member authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
