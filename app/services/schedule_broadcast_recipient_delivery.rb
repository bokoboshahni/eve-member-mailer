# frozen_string_literal: true

# Schedules delivery of a broadcast to an individual recipient.
class ScheduleBroadcastRecipientDelivery < ApplicationService
  attr_reader :delivery

  def initialize(broadcast, recipient)
    super

    @broadcast = broadcast
    @recipient = recipient
  end

  def call
    return if existing_delivery&.delivered?

    schedule_for = broadcast.scheduled_at

    return update_delivery(schedule_for) if existing_delivery

    create_delivery(schedule_for)
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.warn("Delivery has already been scheduled for broadcast #{broadcast.id} and recipient #{recipient.id}")
  end

  private

  attr_reader :broadcast, :recipient

  delegate :corporation, :sender, to: :broadcast

  def create_delivery(schedule_for)
    Rails.logger.info("Scheduling broadcast delivery to #{recipient} from #{sender} for #{broadcast.name}")
    @delivery = Delivery.create!(
      broadcast: broadcast,
      corporation: corporation,
      member: recipient,
      kind: 'broadcast',
      scheduled_at: schedule_for,
      status: 'scheduled',
      user: sender
    )
  end

  def update_delivery(schedule_for)
    Rails.logger.info("Updating schedule for delivery #{existing_delivery.id} to #{schedule_for}")
    delivery.update!(scheduled_at: schedule_for, user: broadcast.sender)
  end

  def existing_delivery
    @existing_delivery ||= Delivery.find_by(broadcast_id: broadcast.id, member_id: recipient.id)
  end
end
