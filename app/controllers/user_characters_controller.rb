# frozen_string_literal: true

class UserCharactersController < AuthenticatedController
  before_action :find_user_character, only: %i[destroy]

  layout 'user_settings'

  def index
    @user_characters = current_user.user_characters
  end

  def create
    authorize(current_user.user_characters)

    state = session['omniauth.state'] = SecureRandom.hex
    redirect_to oauth.auth_code.authorize_url(redirect_uri: redirect_uri, scope: scopes, state: state)
  end

  def destroy
    if params[:id].to_i == current_user.main_character_id
      remove_api_access(@user_character)
    else
      @user_character.destroy
      flash[:success] = 'Character successfully removed.'
    end

    redirect_to settings_characters_path
  end

  private

  def remove_api_access(user_character)
    if DestroyAuthorization.new(user_character.character_id).destroy
      flash[:success] = 'Successfully removed API access from main character.'
    else
      flash[:error] = 'Error removing API access from main character.'
    end
  end

  def find_user_character
    @user_character = current_user.user_characters.find_by!(character_id: params[:id])
  end

  def oauth
    @oauth = OAuth2::Client.new(
      Rails.application.config.x.esi.client_id,
      Rails.application.config.x.esi.client_secret,
      site: Rails.application.config.x.esi.oauth_url
    )
  end

  def redirect_uri
    Rails.application.config.x.esi.redirect_uri
  end

  def scopes
    Rails.application.config.x.esi.scopes.join(' ')
  end
end
