# frozen_string_literal: true

# Character settings controller.
class CharacterSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_character, only: %i[destroy]

  layout 'settings'

  def index
    @user_characters = authorize(current_user.user_characters)
  end

  def destroy
    if params[:id].to_i == current_user.main_character_id
      remove_api_access(@user_character)
    else
      @user_character.destroy
      flash[:success] = 'Character successfully removed.'
    end

    redirect_to settings_characters_path
  end

  private

  def remove_api_access(user_character)
    if DestroyAuthorization.new(user_character.character_id).destroy
      flash[:success] = 'Successfully removed API access from main character.'
    else
      flash[:error] = 'Error removing API access from main character.'
    end
  end

  def find_user_character
    @user_character = current_user.user_characters.find_by!(character_id: params[:id])
  end
end
