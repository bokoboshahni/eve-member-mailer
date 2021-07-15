# frozen_string_literal: true

# Syncs character information from ESI.
class SyncESICharacter < ApplicationService
  include ESIHelpers

  # An error that occurs while attempting to sync a character from ESI.
  class Error < RuntimeError; end

  # An error that occurs when the character's start date is unable to be determined.
  class HistoryError < Error; end

  def initialize(character_id)
    super

    @character_id = character_id
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    ActiveRecord::Base.transaction do
      character_attrs = character_attrs_from(esi.character(character_id: character_id))
      sync_alliance!(character_attrs[:alliance_id])
      sync_corporation!(character_attrs[:corporation_id]) unless Corporation.exists?(character_attrs[:corporation_id])
      character = Character.where(id: character_id).first_or_create!(character_attrs)
      character.update!(character_attrs)
      character
    end
  rescue ESI::Client::Error => e
    msg = "Unable to sync character #{character_id} from ESI: #{e.message}"
    raise Error, msg, cause: e
  end

  private

  attr_reader :character_id

  def character_attrs_from(data) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
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

  def character_corporation_start_date(character_id, corporation_id)
    records = character_corporation_history(character_id).select { |i| i['corporation_id'] == corporation_id }
    record = records.max_by { |i| i['record_id'] }
    raise HistoryError, "Unable to find corporation start date for #{character_id}" unless record

    record['start_date']
  end

  def character_corporation_history(character_id)
    esi.character_corporation_history(character_id: character_id)
  end

  def sync_alliance!(alliance_id)
    return if alliance_id.blank?

    return if Alliance.exists?(alliance_id)

    SyncESIAlliance.new(alliance_id).call
  end

  def sync_corporation!(corporation_id)
    return if Corporation.exists?(corporation_id)

    SyncESICorporation.new(corporation_id).call
  end
end
