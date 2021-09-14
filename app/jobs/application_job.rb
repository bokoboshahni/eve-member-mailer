# frozen_string_literal: true

# Base class for jobs.
class ApplicationJob < ActiveJob::Base
  include JobHelpers
end
