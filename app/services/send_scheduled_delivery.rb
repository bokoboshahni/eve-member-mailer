# frozen_string_literal: true

# Sends a scheduled delivery.
class SendScheduledDelivery
  class Error < StandardError; end

  def initialize(delivery)
    @delivery = delivery
  end

  def call # rubocop:disable Metrics/MethodLength
    return remove_recipient unless recipient_matches_corporation?

    return unless delivery.scheduled?

    return if nonexistent_step?

    warn_if_future_delivery
    update_broadcast_delivering_status
    send_evemail
    update_delivery_success_status
    delivery
  rescue StandardError => e
    update_delivery_error_status(e)
    raise
  end

  private

  attr_reader :delivery, :evemail_id

  delegate :broadcast, to: :delivery

  def recipient_info
    @recipient_info ||= GetESICharacter.new(delivery.member.eve_character_id).call
  end

  def recipient_matches_corporation?
    return true if broadcast_to_everyone?

    recipient_info['corporation_id'] == delivery.corporation.eve_corporation_id
  end

  def broadcast_to_everyone?
    delivery.a_broadcast? && delivery.audience == 'everyone'
  end

  def remove_recipient
    Rails.logger.warn("Delivery #{delivery.id} is for a non-corporation member: #{delivery.member.name}")
    RemoveMemberWorker.perform_async(delivery.member_id)
    nil
  end

  def nonexistent_step?
    return unless delivery.a_campaign?

    if delivery.step_id.nil?
      Rails.logger.info("Delivery #{delivery.id} is for a campaign step that no longer exists")
      false
    else
      true
    end
  end

  def warn_if_future_delivery
    Rails.logger.warn("Delivery #{delivery.id} is scheduled in the future") if Time.zone.now < delivery.scheduled_at
  end

  def update_broadcast_delivering_status
    return unless delivery.a_broadcast?

    broadcast.update!(status: 'delivering')
  end

  def send_evemail
    Rails.logger.info("Sending EVEmail for delivery #{delivery.id}")
    @evemail_id = SendEVEMailFromTemplate.new(sender, recipient, subject, body).call
  end

  def update_delivery_success_status
    delivery.update!(delivered_at: Time.zone.now, status: 'delivered', evemail_id: evemail_id)
  end

  def update_delivery_error_status(error)
    delivery.update!(status: 'error', status_description: "Delivery error: #{error.message}")
  end

  def subject
    case delivery.kind
    when 'broadcast'
      delivery.broadcast.subject
    when 'campaign', 'test'
      delivery.template.subject
    end
  end

  def body
    case delivery.kind
    when 'broadcast'
      delivery.broadcast.body
    when 'campaign', 'test'
      delivery.template.body
    end
  end

  def sender
    delivery.user
  end

  def recipient
    'corporation' if delivery.a_broadcast? && delivery.audience == 'everyone'

    delivery.member
  end
end
