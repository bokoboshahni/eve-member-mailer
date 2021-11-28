# frozen_string_literal: true

class SendEVEMail < ApplicationService
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
    esi.post_character_mail(character_id: sender.id, params: params)
  end

  private

  attr_reader :sender, :recipient, :subject, :body
end
