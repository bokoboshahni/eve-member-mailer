# frozen_string_literal: true

# Discards old corporation members and adds new ones to the database from ESI.
class SyncCorporationMembersWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_corporations'

  # Completion callback for batch.
  class Callback
    def on_complete(status, options)
      corporation = Corporation.find(options['corporation_id'])
      corporation.update!(sync_batch_id: nil, sync_batch_status: nil, last_sync_batch_id: status.bid,
                          last_sync_batch_status: status.data)

      Rails.logger.info("Syncing corporation list members for #{corporation.name}")
      SyncCorporationListMembersWorker.perform_async(options['corporation_id'])
    end
  end

  def perform(corporation_id, user_id) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    corporation = Corporation.find(corporation_id)
    user = User.find(user_id)

    current_members = corporation.members.kept.select(:eve_character_id).map(&:eve_character_id)
    updated_members = GetESICorporationMembers.new(corporation, user).call
    new_members = updated_members - current_members
    old_members = current_members - updated_members

    corporation.members.kept.where(eve_character_id: old_members).each(&:discard!)

    if new_members.empty?
      Rails.logger.info("Syncing corporation list members for #{corporation.name}")
      SyncCorporationListMembersWorker.perform_async(corporation_id)
      return
    end

    batch = Sidekiq::Batch.new
    batch.description = "Syncing new members for #{corporation.name}"
    batch.on(:complete, SyncCorporationMembersWorker::Callback, 'corporation_id' => corporation.id)
    batch.jobs do
      corporation.members.kept.where(eve_character_id: old_members).each { |m| RemoveMemberWorker.perform_async(m.id) }
      new_members.each do |id|
        Rails.logger.info("Syncing #{corporation.name} member #{id}")
        SyncMemberWorker.perform_async(id, corporation.id)
      end
    end
    corporation.update!(sync_batch_id: batch.bid, sync_batch_status: Sidekiq::Batch::Status.new(batch.bid).data)
  end
end
