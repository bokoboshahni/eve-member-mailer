# frozen_string_literal: true

# Sends an EVEMail from a template.
class SendEVEMailFromTemplate < ApplicationService
  def initialize(sender, recipient, subject, body)
    super

    @sender = sender
    @recipient = recipient
    @subject = subject
    @body = body
    @corporation = sender.corporation
  end

  def call
    SendEVEMail.new(sender, recipient, rendered_subject, rendered_body).call
  end

  private

  attr_reader :corporation, :sender, :recipient, :subject, :body

  def context
    {
      'corporation' => corporation.name,
      'sender' => sender.eve_character_name,
      'recipient' => recipient.name
    }
  end

  def rendered_subject
    @rendered_subject ||= RenderLiquidTemplate.new(subject, context).call
  end

  def rendered_body
    @rendered_body ||= RenderLiquidTemplate.new(body, context).call
  end
end
