# frozen_string_literal: true

# Removes a member from a corporation.
class RemoveMember < ApplicationService
  def initialize(member)
    super

    @member = member
  end

  def call
    member.transaction do
      # Remove any scheduled deliveries.
      member.deliveries.scheduled.destroy_all

      # Remove the member from any lists and campaigns.
      member.campaign_members.destroy_all
      member.list_members.destroy_all

      # Discard the member.
      member.discard
    end
  end

  private

  attr_reader :member
end
