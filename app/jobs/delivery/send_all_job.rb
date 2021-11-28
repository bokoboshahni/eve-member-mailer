# frozen_string_literal: true

class Delivery < ApplicationRecord
  class SendAllJob < ApplicationJob
    sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

    class Callback
      def on_complete(_status, _options)
        Broadcast.all.each(&:update_delivered)
      end
    end

    def perform
      deliveries = Delivery.where(scheduled_at: ..Time.zone.now, status: 'scheduled')
      batch = Sidekiq::Batch.new
      batch.on(:complete, Delivery::SendAllJob::Callback)
      batch.jobs { deliveries.each { |d| SendScheduledDeliveryJob.perform_later(d.id, d.user_id) } }
    end
  end
end
