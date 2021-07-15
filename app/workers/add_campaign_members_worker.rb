# frozen_string_literal: true

# Adds new campaign members.
class AddCampaignMembersWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_campaigns'

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    new_members = FindNewCampaignMembers.new(campaign).call
    Rails.logger.info("Found #{new_members.count} new member(s) for campaign #{campaign.name} (#{campaign.id})")
    AddNewCampaignMembers.new(campaign, new_members).call

    batch = Sidekiq::Batch.new
    batch.jobs do
      new_members.each do |member|
        ScheduleCampaignMemberDeliveriesWorker.perform_async(campaign_id, member.id)
      end
    end
  end
end
