# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit

  after_action :verify_authorized, unless: -> { controller_name == 'sessions' }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  add_flash_types :info, :error, :warning, :success, :list

  protected

  helper_method :rollout
  def rollout
    Rails.application.config.rollout
  end

  private

  def user_not_authorized(_exception)
    flash[:error] = 'You are not authorized to do that.'
    redirect_to(request.referer || root_path)
  end

  helper_method :current_nav
  def current_nav
    @current_nav || controller_name
  end

  def set_current(nav) # rubocop:disable Naming/AccessorMethodName
    @current_nav = nav.to_s
  end

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
  end
end
