# frozen_string_literal: true

# Refreshes an ESI access token if it is expired.
class RefreshToken
  def initialize(authorization)
    @authorization = authorization
  end

  def call
    return unless current_token.expired?

    Rails.logger.debug("Refreshing ESI token for character #{user_character.character_id}")
    new_token = current_token.refresh!
    user_character.update!(
      esi_access_token: new_token.token,
      esi_refresh_token: new_token.refresh_token,
      esi_expires_at: Time.zone.at(new_token.expires_at).to_datetime
    )
  end

  private

  attr_reader :authorization

  def current_token
    @current_token ||= OAuth2::AccessToken.from_hash(client,
                                                     access_token: authorization.access_token,
                                                     refresh_token: authorization.refresh_token,
                                                     expires_at: authorization.expires_at)
  end

  def client
    @client ||= OAuth2::Client.new(esi_config.api_client_id, esi_config.api_client_secret, site: esi_config.oauth_url)
  end

  def esi_config
    Rails.application.config.x.esi
  end
end
