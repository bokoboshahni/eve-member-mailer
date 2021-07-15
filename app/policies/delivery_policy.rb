# frozen_string_literal: true

# Authorization policy for deliveries.
class DeliveryPolicy < ApplicationPolicy
  # Scope for delivery authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
