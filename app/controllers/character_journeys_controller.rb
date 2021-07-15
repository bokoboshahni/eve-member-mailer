# frozen_string_literal: true

class CharacterJourneysController < ApplicationController
  before_action :authenticate_user!
end
