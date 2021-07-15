# frozen_string_literal: true

# Controller for template tests.
class TemplateTestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_template
  before_action -> { set_current(:templates) }

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    recipient = current_corporation.members.find_by(name: template_test_params[:recipient])
    if recipient
      delivery = Delivery.create(kind: 'test', member: recipient, user: current_user, scheduled_at: Time.zone.now,
                                 status: 'scheduled', template: @template)
      SendScheduledDeliveryJob.perform_later(delivery.id)
      flash[:success] = "Test EVEMail sent to #{recipient.name}"
      redirect_to template_path(@template)
    else
      flash[:error] = "#{template_test_params[:recipient]} is not a valid recipient."
      render :new
    end
  end

  private

  def template_test_params
    params.permit(:recipient)
  end

  def find_template
    @template = authorize(current_corporation.templates.find(params[:template_id]))
  end
end
