# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def current_user_image_url(size = 512)
    eve_character_image_url(current_user.main_character_id, size)
  end

  def eve_character_image_url(character_id, size = 512)
    "https://images.evetech.net/characters/#{character_id}/portrait?size=#{size}"
  end

  def current_nav?(nav)
    current_nav == nav
  end
end
