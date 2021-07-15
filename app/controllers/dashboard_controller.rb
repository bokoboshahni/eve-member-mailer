# frozen_string_literal: true

# Dashboard controller.
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize(:dashboard, :index?)
  end
end
