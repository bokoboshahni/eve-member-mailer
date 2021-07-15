# frozen_string_literal: true

# Dashboard authorization policy.
class DashboardPolicy < ApplicationPolicy
  def index?
    true
  end

  # Scope for authorization.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
