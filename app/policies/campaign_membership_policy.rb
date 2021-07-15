# frozen_string_literal: true

# Authorization policy for campaign memberships.
class CampaignMembershipPolicy < ApplicationPolicy
  # Authorization policy scope for campaign memberships.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
