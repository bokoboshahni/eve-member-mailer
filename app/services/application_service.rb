# frozen_string_literal: true

# Base class for services.
class ApplicationService
  include ServiceHelpers

  def self.call(*args)
    new(*args).call
  end

  def initialize(*args); end
end
