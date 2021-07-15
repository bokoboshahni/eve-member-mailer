# frozen_string_literal: true

# Authorization policy for campaign members.
class CampaignMemberPolicy < ApplicationPolicy
  # Scope for campaign member authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
