# frozen_string_literal: true

class CorporationsController < AuthenticatedController
  before_action :find_corporation, only: %i[show]

  def index
    authorize(Corporation)
    @pagy, @corporations = pagy(current_user.accessible_corporations.order(:name))
  end

  def show; end

  private

  def find_corporation
    @corporation = authorize(current_user.accessible_corporations.find(params[:id]))
  end
end
