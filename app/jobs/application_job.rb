# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include JobHelpers

  def cancelled?
    Sidekiq.redis { |c| c.exists?("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86_400, 1) }
  end
end
