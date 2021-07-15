# frozen_string_literal: true

# Controller for reports.
class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize(:report, :index?)
  end
end
