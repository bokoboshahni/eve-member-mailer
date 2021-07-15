# frozen_string_literal: true

# Controller for settings.
class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize(current_user)
  end
end
