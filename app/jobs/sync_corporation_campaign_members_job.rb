# frozen_string_literal: true

# Adds new corporation members to each campaign.
class SyncCorporationCampaignMembersJob < ApplicationJob
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_campaigns'

  def perform(corporation_id)
    corporation = Corporation.find(corporation_id)
    campaigns = corporation.campaigns.kept
    batch = Sidekiq::Batch.new
    batch.jobs do
      campaigns.each { |campaign| AddCampaignMembersJob.perform_later(campaign.id) }
    end
  end
end
