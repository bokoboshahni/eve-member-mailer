# frozen_string_literal: true

class CharacterJourneyStepsController < ApplicationController
  before_action :authenticate_user!
end
