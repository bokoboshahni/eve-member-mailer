# frozen_string_literal: true

# Base class for jobs.
class ApplicationJob < ActiveJob::Base
  protected

  def rollout
    Rails.application.config.rollout
  end
end
