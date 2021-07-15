# frozen_string_literal: true

# Helpers for ESI authentication.
module AuthenticationHelpers
  extend ActiveSupport::Concern

  included do
    attr_reader :auth_info
  end

  def initialize(auth_info)
    @auth_info = auth_info
  end

  protected

  def sync_character!
    SyncESICharacter.new(character_id).call
  end

  def character_id
    auth_info.uid.to_i
  end
end
