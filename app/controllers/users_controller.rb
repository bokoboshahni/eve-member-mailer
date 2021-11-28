# frozen_string_literal: true

class UsersController < AuthenticatedController
  def show
    authorize(current_user)
  end
end
