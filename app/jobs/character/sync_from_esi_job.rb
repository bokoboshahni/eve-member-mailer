# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncFromESIJob < ApplicationJob
    sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

    def perform(character_id)
      Character::SyncFromESI.call(character_id)
      Character::SyncCorporationMembershipJob.call(character_id)
    end
  end
end
