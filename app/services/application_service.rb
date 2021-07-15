# frozen_string_literal: true

# Base class for services.
class ApplicationService
  def initialize(*args); end

  protected

  def rollout
    Rails.application.config.rollout
  end
end
