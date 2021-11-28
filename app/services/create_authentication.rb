# frozen_string_literal: true

class CreateAuthentication < ApplicationService
  class Error < RuntimeError; end

  class NotAllowedError < Error; end

  include AuthHelpers

  def call
    @character = sync_character!
    @corporation = sync_corporation!(character.corporation_id)
    @alliance = sync_alliance!(corporation.alliance_id) if corporation.alliance_id.present?

    raise NotAllowedError unless character_allowed?

    # If we find an existing user->character relation, sync the character and return the user.
    return user_character.user if user_character

    # Otherwise, sync the character, create a new user, and assign the character as the user's main character.
    create_user!
  end

  private

  attr_reader :character, :corporation, :alliance

  delegate :id, to: :character, prefix: true
  delegate :id, to: :corporation, prefix: true
  delegate :id, to: :alliance, prefix: true, allow_nil: true

  delegate :allowed_alliance_ids, :allowed_corporation_ids, to: :emm

  def character_allowed?
    allowed_alliance_ids.include?(alliance_id) ||
      allowed_corporation_ids.include?(corporation_id)
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
end
