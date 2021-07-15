# frozen_string_literal: true

# Sends all scheduled deliveries whose scheduled_at time is older than when the job is run.
class SendAllScheduledDeliveriesWorker < ApplicationWorker
  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'send_deliveries'

  # Completion callback for batch.
  class Callback
    def on_complete(_status, _options)
      Broadcast.all.each(&:update_delivered)
    end
  end

  def perform
    deliveries = Delivery.where(scheduled_at: ..Time.zone.now, status: 'scheduled')
    batch = Sidekiq::Batch.new
    batch.on(:complete, SendAllScheduledDeliveriesWorker::Callback)
    batch.jobs { deliveries.each { |d| SendScheduledDeliveryWorker.perform_async(d.id, d.user_id) } }
  end
end
