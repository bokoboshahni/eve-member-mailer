# frozen_string_literal: true

# Schedules deliveries for all members of a campaign.
class ScheduleCampaignDeliveriesWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'schedule_deliveries'

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    Rails.logger.info("Scheduling campaign deliveries for #{campaign.name}")

    batch = Sidekiq::Batch.new
    batch.jobs do
      campaign.members.each do |member|
        Rails.logger.info("Scheduling campaign deliveries for #{campaign.name} to #{member.name}")
        ScheduleCampaignMemberDeliveriesWorker.perform_async(campaign_id, member.id)
      end
    end
  end
end
