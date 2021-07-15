# frozen_string_literal: true

# Schedules delivery for a recipient of a broadcast.
class ScheduleBroadcastRecipientDeliveryWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'schedule_deliveries'

  def perform(broadcast_id, member_id)
    broadcast = Broadcast.find(broadcast_id)
    recipient = broadcast.recipients.find(member_id)
    ScheduleBroadcastRecipientDelivery.new(broadcast, recipient).call
  end
end
