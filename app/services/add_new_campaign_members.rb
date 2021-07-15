# frozen_string_literal: true

# Adds new members to a campaign.
class AddNewCampaignMembers < ApplicationService
  def initialize(campaign, new_members)
    super

    @campaign = campaign
    @new_members = new_members
  end

  def call
    campaign.campaign_members.create!(new_members.map { |m| { member_id: m.id, status: 'active' } })
  end

  private

  attr_reader :campaign, :new_members
end
