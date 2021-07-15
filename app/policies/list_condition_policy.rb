# frozen_string_literal: true

# Authorization policy for list conditions.
class ListConditionPolicy < ApplicationPolicy
  def reorder?
    user_in_record_corporation? && user_can_edit?
  end

  # Scope for list condition authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
