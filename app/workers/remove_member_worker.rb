# frozen_string_literal: true

# Removes a corporation member.
class RemoveMemberWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'sync_corporations'

  def perform(member_id)
    member = Member.find(member_id)
    RemoveMember.new(member).call
    Rails.logger.info("Removed #{member.name} (#{member.eve_character_id}) from #{member.corporation.name}")
  end
end
