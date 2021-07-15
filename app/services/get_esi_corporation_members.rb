# frozen_string_literal: true

# Fetches current corporation member IDs from ESI.
class GetESICorporationMembers
  include ESIHelpers

  def initialize(corporation, user)
    @corporation = corporation
    @user = user
  end

  def call
    esi_user_get(esi, user, "/latest/corporations/#{corporation.eve_corporation_id}/members")
  end

  private

  attr_reader :corporation, :user

  def esi
    @esi ||= esi_client(user)
  end
end
