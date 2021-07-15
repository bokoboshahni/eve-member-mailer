# frozen_string_literal: true

# Authorization policy for campaign triggers.
class CampaignTriggerPolicy < ApplicationPolicy
  # Scope for campaign trigger authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
