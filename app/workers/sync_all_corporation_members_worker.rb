# frozen_string_literal: true

# Syncs members for all corporations.
class SyncAllCorporationMembersWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_corporations'

  def perform
    batch = Sidekiq::Batch.new
    batch.jobs do
      Corporation.kept.each do |corporation|
        next if corporation.users.empty?

        Rails.logger.info("Syncing members for corporation #{corporation.name} (#{corporation.id}}")
        SyncCorporationMembersWorker.perform_async(corporation.id, corporation.esi_user.id)
      end
    end
  end
end
