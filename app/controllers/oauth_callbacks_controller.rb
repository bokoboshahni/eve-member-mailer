# frozen_string_literal: true

class OAuthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[eve]
  skip_after_action :verify_authorized

  def eve
    if scopes.empty?
      authenticate
    else
      authorize
    end
  end

  def failure
    flash[:error] = 'Authentication failed.'
    redirect_to(request.referer || root_path)
  end

  private

  def authorize
    redirect_to root_path unless user_signed_in?

    Authorization::Create.call(auth_info, current_user)
    flash[:success] = 'Character authorized successfully.'
    redirect_to character_settings_path
  rescue Authorization::Create::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to authorize character.'
    redirect_to character_settings_path
  end

  def authenticate
    user = CreateAuthentication.call(auth_info)
    sign_in_and_redirect(user, event: :authentication)
  rescue Character::SyncFromESI::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to sync character.'
  rescue CreateAuthentication::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to log in.'
    redirect_to root_path
  end

  def auth_info
    request.env['omniauth.auth']
  end

  def scopes
    auth_info.info.scopes.split
  end
end
