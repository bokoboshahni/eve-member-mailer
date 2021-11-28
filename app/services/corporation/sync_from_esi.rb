# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(corporation_id)
      super

      @corporation_id = corporation_id
    end

    def call
      corporation_attrs = corporation_attrs_from_esi
      corporation_attrs.merge!(corporation_icon_attrs_from_esi)
      corporation = Corporation.where(id: corporation_id).first_or_create!(corporation_attrs)
      corporation.update!(corporation_attrs)
      corporation
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync corporation #{corporation_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :corporation_id

    def corporation_attrs_from_esi
      data = esi.get_corporation(corporation_id: corporation_id)

      {
        alliance_id: data['alliance_id'],
        description: data['description'],
        faction_id: data['faction_id'],
        name: data['name'],
        ticker: data['ticker'],
        url: data['url']
      }
    end

    def corporation_icon_attrs_from_esi
      data = esi.get_corporation_icons(corporation_id: corporation_id)

      {
        icon_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
        icon_url_256: data['px256x256'], # rubocop:disable Naming/VariableNumber
        icon_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
      }
    end
  end
end
