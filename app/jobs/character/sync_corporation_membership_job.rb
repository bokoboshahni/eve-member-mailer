# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncCorporationMembershipJob < ApplicationJob
    sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

    def perform(character_id)
      character = Character.find(character_id)
      Character::SyncCorporationMembership.call(character)
    end
  end
end
