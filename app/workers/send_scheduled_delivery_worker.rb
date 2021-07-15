# frozen_string_literal: true

# Sends a scheduled delivery.
class SendScheduledDeliveryWorker < ApplicationWorker
  include Sidekiq::Throttled::Worker

  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise, queue: 'send_deliveries'

  sidekiq_throttle threshold: { limit: 5, period: 1.minute }, key_suffix: ->(sender_id) { sender_id }

  def perform(delivery_id, _sender_id)
    delivery = Delivery.find(delivery_id)
    SendScheduledDelivery.new(delivery).call
  end
end
