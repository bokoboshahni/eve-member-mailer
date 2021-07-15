# frozen_string_literal: true

# Authenticates a user for login via EVE SSO.
class CreateAuthentication
  class Error < RuntimeError; end

  class NotAllowedError < Error; end

  class SyncError < Error; end

  include AuthenticationHelpers

  def call
    @character = sync_character!

    raise NotAllowedError unless character_allowed?

    # If we find an existing user->character relation, sync the character and return the user.
    return user_character.user if user_character

    # Otherwise, sync the character, create a new user, and assign the character as the user's main character.
    create_user!
  end

  private

  attr_reader :character

  def character_allowed?
    allowed_alliance_ids.include?(character.alliance_id.to_s) ||
      allowed_corporation_ids.include?(character.corporation_id.to_s)
  end

  def user_character
    @user_character ||= UserCharacter.find_by(character_id: character_id)
  end

  def create_user!
    ActiveRecord::Base.transaction do
      user = User.create!
      user.main_character = character
      user
    end
  end

  def allowed_alliance_ids
    emm_config.allowed_alliance_ids
  end

  def allowed_corporation_ids
    emm_config.allowed_corporation_ids
  end

  def emm_config
    Rails.application.config.x.emm
  end
end
