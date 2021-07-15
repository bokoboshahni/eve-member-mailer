# frozen_string_literal: true

# Authorization policy for campaign filters.
class CampaignFilterPolicy < ApplicationPolicy
  # Authorization policy scope for campaign filters.
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
