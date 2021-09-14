# frozen_string_literal: true

# Syncs alliance information from ESI.
class SyncESIAlliance < ApplicationService
  include ESIHelpers

  class Error < RuntimeError; end

  def initialize(alliance_id)
    super

    @alliance_id = alliance_id
  end

  def call
    alliance_attrs = alliance_attrs_from(esi.get_alliance(alliance_id: alliance_id))
    alliance = Alliance.where(id: alliance_id).first_or_create!(alliance_attrs)
    alliance.update!(alliance_attrs)
    alliance
  rescue ESI::Errors::ClientError => e
    msg = "Unable to sync alliance #{alliance_id} from ESI: #{e.message}"
    raise Error, msg, cause: e
  end

  private

  attr_reader :alliance_id

  def alliance_attrs_from(data)
    {
      faction_id: data['faction_id'].to_i,
      name: data['name']
    }
  end
end
