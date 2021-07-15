# frozen_string_literal: true

# Adds new list members.
class AddListMembersWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_lists'

  def perform(list_id, resync_campaigns = false) # rubocop:disable Metrics/AbcSize, Style/OptionalBooleanParameter
    list = List.find(list_id)
    new_members = FindNewListMembers.new(list).call
    Rails.logger.info("Found #{new_members.count} new member(s) for list #{list.name} (#{list.name})")
    AddNewListMembers.new(list, new_members).call

    return unless resync_campaigns

    list.campaigns.each do |campaign|
      Rails.logger.info("Queuing campaign sync for #{campaign.name}")
      AddCampaignMembersWorker.perform_async(campaign.id)
    end
  end
end
