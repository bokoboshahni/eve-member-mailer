# frozen_string_literal: true

# Schedules deliveries for a member of a campaign.
class ScheduleCampaignMemberDeliveriesJob < ApplicationJob
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'schedule_deliveries'

  def perform(campaign_id, member_id)
    campaign = Campaign.find(campaign_id)
    member = campaign.members.find(member_id)
    ScheduleCampaignMemberDeliveries.new(campaign, member).call
  end
end
