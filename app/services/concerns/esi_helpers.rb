# frozen_string_literal: true

require 'esi/client'

# Helpers for ESI API calls.
module ESIHelpers
  extend ActiveSupport::Concern

  def esi
    @esi ||= ESI::Client.new(user_agent: Rails.application.config.x.esi.user_agent)
  end

  def esi_authorize!(character_id)
    authorization = Authorization.find_by!(character_id: character_id, kind: 'esi')
    authorization.refresh_esi_token!
    esi.authorize(authorization.access_token)
  end
end
