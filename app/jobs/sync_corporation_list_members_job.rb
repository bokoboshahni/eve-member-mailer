# frozen_string_literal: true

# Adds new corporation members to each list.
class SyncCorporationListMembersJob < ApplicationJob
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_lists'

  # Completion callback for batch.
  class Callback
    def on_complete(_status, options)
      SyncCorporationCampaignMembersJob.perform_later(options['corporation_id'])
    end
  end

  def perform(corporation_id)
    corporation = Corporation.find(corporation_id)
    lists = corporation.lists.kept
    batch = Sidekiq::Batch.new
    batch.on(:complete, SyncCorporationListMembersJob::Callback, 'corporation_id' => corporation.id)
    batch.jobs do
      lists.each { |list| AddListMembersJob.perform_later(list.id) }
    end
  end
end
