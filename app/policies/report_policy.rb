# frozen_string_literal: true

# Authorization policy for reports.
class ReportPolicy < ApplicationPolicy
  # Scope for authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
