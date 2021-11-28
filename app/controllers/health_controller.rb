# frozen_string_literal: true

class HealthController < ApplicationController
  skip_after_action :verify_authorized

  def show
    render json: { status: 'ok' }.to_json
  end
end
