# frozen_string_literal: true

class Authorization < ApplicationRecord
  class RefreshToken < AuthorizationService
    def call
      return unless current_token.expired?

      logger.debug("Refreshing ESI token for character \"#{character_name}\" (#{character_id})")
      new_token = current_token.refresh!
      authorization.update!(
        access_token: new_token.token,
        refresh_token: new_token.refresh_token,
        expires_at: Time.zone.at(new_token.expires_at).to_datetime
      )
    end

    private

    delegate :character, to: :authorization
    delegate :id, :name, to: :character, prefix: true

    def current_token
      @current_token ||= OAuth2::AccessToken.from_hash(client,
                                                       access_token: authorization.access_token,
                                                       refresh_token: authorization.refresh_token,
                                                       expires_at: authorization.expires_at)
    end

    def client
      @client ||= OAuth2::Client.new(esi_config.client_id, esi_config.client_secret, site: esi_config.oauth_url)
    end

    def esi_config
      config.x.esi
    end
  end
end
