# frozen_string_literal: true

# Authorization policy for campaigns.
class CampaignPolicy < ApplicationPolicy\
  # Scope for campaign authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
