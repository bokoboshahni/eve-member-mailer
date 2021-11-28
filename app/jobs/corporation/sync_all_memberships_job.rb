# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncAllMembersJob < ApplicationJob
    sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

    def perform
      batch = Sidekiq::Batch.new
      batch.jobs do
        Corporation.kept.each do |corporation|
          next if corporation.characters.empty?

          Corporation::SyncMembersJob.perform_later(corporation.id)
        end
      end
    end
  end
end
