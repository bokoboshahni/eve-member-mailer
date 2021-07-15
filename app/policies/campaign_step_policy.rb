# frozen_string_literal: true

# Authorization policy for campaign steps.
class CampaignStepPolicy < ApplicationPolicy
  # Scope for campaign step authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
