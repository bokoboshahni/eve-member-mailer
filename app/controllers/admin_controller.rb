# frozen_string_literal: true

class AdminController < AuthenticatedController
  before_action :authorize_admin!

  private

  def authorize_admin!
    redirect_to dashboard_path unless current_user.admin?
  end
end
