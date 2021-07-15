# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit

  after_action :verify_authorized, unless: -> { controller_name == 'sessions' }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  add_flash_types :info, :error, :warning, :success, :list

  private

  def info_for_papertrail
    { user_id: current_user.id }
  end

  def user_for_papertrail
    current_user.id
  end

  def user_not_authorized(_exception)
    flash[:error] = 'You are not authorized to do that.'
    redirect_to(request.referer || root_path)
  end

  helper_method :current_nav
  def current_nav
    @current_nav || controller_name
  end

  helper_method :current_corporation
  def current_corporation
    @current_corporation ||= current_user.corporation
  end

  def set_current(nav) # rubocop:disable Naming/AccessorMethodName
    @current_nav = nav.to_s
  end
end
