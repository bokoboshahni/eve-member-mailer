# frozen_string_literal: true

# Schedules deliveries for all recipients of a broadcast.
class ScheduleBroadcastDeliveriesJob < ApplicationJob
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'schedule_deliveries'

  # Completion callback for batch.
  class Callback
    def on_complete(status, options)
      broadcast = Broadcast.find(options['broadcast_id'])
      broadcast.update(status: 'scheduled', schedule_batch_status: status.data)
    end
  end

  def perform(broadcast_id)
    broadcast = find_broadcast(broadcast_id)
    Rails.logger.info("Scheduling broadcast deliveries for #{broadcast.name}")

    return ScheduleBroadcastEveryoneDelivery.new(broadcast).call if broadcast.audience == 'everyone'

    batch = create_batch(broadcast)
    batch.jobs do
      broadcast.recipients.each do |recipient|
        schedule_broadcast_recipient_delivery(broadcast, recipient)
      end
    end
    update_broadcast_status(broadcast, batch)
  end

  private

  def find_broadcast(broadcast_id)
    Broadcast.find(broadcast_id)
  end

  def create_batch(broadcast)
    batch = Sidekiq::Batch.new
    batch.on(:complete, ScheduleBroadcastDeliveriesJob::Callback, 'broadcast_id' => broadcast.id)
    batch
  end

  def schedule_broadcast_recipient_delivery(broadcast, recipient)
    Rails.logger.info("Scheduling broadcast deliveries for #{broadcast.name} to #{recipient.name}")
    ScheduleBroadcastRecipientDeliveryJob.perform_later(broadcast.id, recipient.id)
  end

  def update_broadcast_status(broadcast, batch)
    batch_status = Sidekiq::Batch::Status.new(batch.bid)
    broadcast.update(status: 'scheduling', schedule_batch_id: batch.bid, schedule_batch_status: batch_status.data)
  end
end
