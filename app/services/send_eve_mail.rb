# frozen_string_literal: true

# Sends an EVEMail.
class SendEVEMail < ApplicationService
  # An error sending an EVEmail.
  class DeliveryError < StandardError; end

  include ESIHelpers

  def initialize(sender, recipient, subject, body)
    super

    @sender = sender
    @recipient = recipient
    @subject = subject
    @body = body
  end

  def call
    params = {
      recipients: [
        { recipient_id: recipient.eve_character_id, recipient_type: 'character' }
      ],
      subject: subject,
      body: body
    }
    response = esi_user_post(esi, sender, "/latest/characters/#{sender.eve_character_id}/mail", {}, {}, params)

    raise DeliveryError, "#{response.status} #{response.body['error']}" unless response.success?

    response.body
  end

  private

  attr_reader :sender, :recipient, :subject, :body

  def esi
    @esi ||= esi_client(sender, :json)
  end
end
