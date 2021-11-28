# frozen_string_literal: true

class DashboardController < AuthenticatedController
  def index
    authorize(:dashboard, :index?)
  end
end
