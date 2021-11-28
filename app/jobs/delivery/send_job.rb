# frozen_string_literal: true

class SendScheduledDeliveryJob < ApplicationJob
  include Sidekiq::Throttled::Worker

  sidekiq_options retry: 5, lock_until: :while_executing, on_conflict: :raise

  sidekiq_throttle threshold: { limit: 5, period: 1.minute }, key_suffix: ->(sender_id) { sender_id }

  def perform(delivery_id)
    delivery = Delivery.find(delivery_id)
    Delivery::Send.call(delivery)
  end
end
