# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncMembersJob < ApplicationJob
    sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

    class Callback
      def on_success(_sidekiq_status, options)
        status = BatchStatus.find(options['status_id'])
        corporation = status.subject
        status.update!(status: :succeeded, failures: 0, failure_info: [], completed_at: now)
        logger.info("Successfully synced corporation memberships for \"#{corporation.name}\" (#{corporation.id})")
      end

      def on_death(sidekiq_status, options)
        status = BatchStatus.find(options['status_id'])
        corporation = status.subject
        status.update!(status: :failed, failures: sidekiq_status.failures, failure_info: sidekiq_status.failure_info,
                       completed_at: now)
        logger.error("Synced corporation memberships with failures for \"#{corporation.name}\" (#{corporation.id})")
      end

      private

      def now
        @now ||= Time.zone.now
      end
    end

    def perform(corporation_id) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      corporation = Corporation.find(corporation_id)
      status = BatchStatus.create!(kind: 'sync_corporation_memberships', subject: corporation, status: 'started')

      esi_authorize!(corporation.primary_authorization)

      current_member_ids = corporation.characters.pluck(:id)
      updated_member_ids = esi.get_corporation_members(corporation_id: corporation_id)
      all_member_ids = (current_member_ids + updated_member_ids).uniq

      batch = Sidekiq::Batch.new
      batch.description = "SyncCorporationMembershipsJob(#{corporation_id})"
      batch.on(:success, SyncMembersJob::Callback, 'status_id' => status.id)
      batch.on(:death, SyncMembersJob::Callback, 'status_id' => status.id)
      batch.jobs do
        all_member_ids.each { |id| Character::SyncCorporationMembershipJob.perform_later(id) }
      end

      logger.info("Queued syncing for corporation memberships for \"#{corporation.name}\" (#{corporation_id}")
    rescue StandardError
      logger.error("Failed to sync corporation memberships for \"#{corporation.name}\" (#{corporation_id}")
      status.update!(completed_at: Time.zone.now, status: 'failed')
      raise
    end
  end
end
