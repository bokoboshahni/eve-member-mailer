# frozen_string_literal: true

class CorporationsController < ApplicationController
  before_action :authenticate_user!
end
