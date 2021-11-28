# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncRolesFromESI < ApplicationService
    def initialize(character)
      super

      @character = character
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      unless character.authorized? && character.authorization.scopes.include?('esi-characters.read_corporation_roles.v1')
        logger.warn("Character #{character_name} (#{character_id}) is not authorized to retrieve roles")
        return
      end

      esi_authorize!(character.authorization)
      data = esi.get_character_roles(character_id: character_id)
      character.update!(corporation_roles: data['roles'].map(&:titleize))
      character['roles']
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync character #{character_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :character

    delegate :id, :name, to: :character, prefix: true
  end
end
