# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    class HistoryError < Error; end

    def initialize(character_id)
      super

      @character_id = character_id
    end

    def call # rubocop:disable Metrics/MethodLength
      ActiveRecord::Base.transaction do
        character_attrs = character_attrs_from_esi
        character_attrs.merge!(portrait_attrs_from_esi)
        sync_alliance!(character_attrs[:alliance_id])
        sync_corporation!(character_attrs[:corporation_id])
        character = Character.where(id: character_id).first_or_create!(character_attrs)
        character.update!(character_attrs)
        character
      end
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync character #{character_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :character_id

    def character_attrs_from_esi # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      data = esi.get_character(character_id: character_id)

      {
        alliance_id: data['alliance_id']&.to_i,
        ancestry_id: data['ancestry_id']&.to_i,
        birthday: data['birthday'],
        bloodline_id: data['bloodline_id']&.to_i,
        corporation_id: data['corporation_id']&.to_i,
        corporation_start_date: character_corporation_start_date(character_id, data['corporation_id']),
        description: data['description'],
        faction_id: data['faction_id']&.to_i,
        gender: data['gender'],
        name: data['name'],
        race_id: data['race_id']&.to_i,
        security_status: data['security_status']&.to_d,
        title: data['title']
      }
    end

    def portrait_attrs_from_esi
      data = esi.get_character_portrait(character_id: character_id)

      {
        portrait_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
        portrait_url_256: data['px256x256'], # rubocop:disable Naming/VariableNumber
        portrait_url_512: data['px512x512'], # rubocop:disable Naming/VariableNumber
        portrait_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
      }
    end

    def corporation_roles_from_esi(character)
      return {} unless character.authorized?

      esi_authorize!(character.authorization)
      data = esi.get_character_roles(character_id: character_id)

      { corporation_roles: data['roles'].map(&:titleize) }
    end

    def character_corporation_start_date(character_id, corporation_id)
      records = character_corporation_history(character_id).select { |i| i['corporation_id'] == corporation_id }
      record = records.max_by { |i| i['record_id'] }
      raise HistoryError, "Unable to find corporation start date for #{character_id}" unless record

      record['start_date']
    end

    def character_corporation_history(character_id)
      esi.get_character_corporation_history(character_id: character_id)
    end

    def sync_alliance!(alliance_id)
      return if alliance_id.blank?

      Alliance::SyncFromESI.call(alliance_id)
    end

    def sync_corporation!(corporation_id)
      Corporation::SyncFromESI.call(corporation_id)
    end
  end
end
