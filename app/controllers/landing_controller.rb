# frozen_string_literal: true

# Landing page controller.
class LandingController < ApplicationController
  skip_after_action :verify_authorized

  def index
    redirect_to dashboard_path if user_signed_in?
  end
end
