# frozen_string_literal: true

# Syncs corporation information from ESI.
class SyncESICorporation < ApplicationService
  include ESIHelpers

  class Error < RuntimeError; end

  def initialize(corporation_id)
    super

    @corporation_id = corporation_id
  end

  def call
    corporation_attrs = corporation_attrs_from(esi.corporation(corporation_id: corporation_id))
    corporation = Corporation.where(id: corporation_id).first_or_create!(corporation_attrs)
    corporation.update!(corporation_attrs)
    corporation
  rescue ESI::Client::Error => e
    msg = "Unable to sync corporation #{corporation_id} from ESI: #{e.message}"
    raise Error, msg, cause: e
  end

  private

  attr_reader :corporation_id

  def corporation_attrs_from(data)
    {
      alliance_id: data['alliance_id'],
      description: data['description'],
      faction_id: data['faction_id'],
      name: data['name'],
      url: data['url']
    }
  end
end
