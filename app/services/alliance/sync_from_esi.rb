# frozen_string_literal: true

class Alliance < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(alliance_id)
      super

      @alliance_id = alliance_id
    end

    def call
      alliance_attrs = alliance_attrs_from_esi
      alliance_attrs.merge!(alliance_icon_attrs_from_esi)
      alliance = Alliance.where(id: alliance_id).first_or_create!(alliance_attrs)
      alliance.update!(alliance_attrs)
      alliance
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync alliance #{alliance_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :alliance_id

    def alliance_attrs_from_esi
      data = esi.get_alliance(alliance_id: alliance_id)

      {
        faction_id: data['faction_id'].to_i,
        name: data['name'],
        ticker: data['ticker']
      }
    end

    def alliance_icon_attrs_from_esi
      data = esi.get_alliance_icons(alliance_id: alliance_id)

      {
        icon_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
        icon_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
      }
    end
  end
end
