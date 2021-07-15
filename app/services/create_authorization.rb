# frozen_string_literal: true

# Adds a character to a user's account and authorizes it for ESI access.
class CreateAuthorization < ApplicationService
  class Error < RuntimeError; end

  class AlreadyInUseError < Error; end

  include AuthenticationHelpers

  def initialize(auth_info, user)
    super(auth_info)
    @user = user
  end

  def call
    raise AlreadyInUseError, 'Character is already in use by another account.' unless character_available?

    ActiveRecord::Base.transaction do
      character = sync_character!
      create_user_character!(character.id)
      create_authorization!(character.id)
    end
  end

  private

  attr_reader :user

  def character_available?
    return true if user_characters.exists?(character_id: character_id)

    return false if UserCharacter.exists?(character_id: character_id) # Character is authorized to any other account.

    true
  end

  def create_user_character!(character_id)
    user_characters.where(character_id: character_id).first_or_create!
  end

  def create_authorization!(character_id)
    authorization_attrs = {
      access_token: auth_info.credentials.token,
      expires_at: Time.zone.at(auth_info.credentials.expires_at).to_datetime,
      kind: 'esi',
      refresh_token: auth_info.credentials.refresh_token
    }
    authorization = Authorization.where(character_id: character_id).first_or_create!(authorization_attrs)
    authorization.update!(authorization_attrs)
  end

  def user_characters
    user.user_characters
  end
end
