# frozen_string_literal: true

# Authorization policy for templates.
class TemplatePolicy < ApplicationPolicy
  # Scope for template authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
