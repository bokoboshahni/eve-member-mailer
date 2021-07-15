# frozen_string_literal: true

# Controller for EVE SSO authentication.
class AuthenticationsController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[api login]
  skip_after_action :verify_authorized

  before_action :authenticate_user!, only: %i[api]

  def api
    CreateAuthorization.new(auth_info, current_user).call
    flash[:success] = 'Character authorized successfully.'
    redirect_to character_settings_path
  rescue CreateAuthorization::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to authorize character.'
    redirect_to character_settings_path
  end

  def login
    user = CreateAuthentication.new(auth_info).call
    sign_in_and_redirect(user, event: :authentication)
  rescue CreateAuthentication::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to log in.'
    redirect_to root_path
  rescue SyncESICharacter::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to sync character.'
  end

  def failure
    flash[:error] = 'Authentication failed.'
    redirect_to(request.referer || root_path)
  end

  private

  def auth_info
    request.env['omniauth.auth']
  end
end
