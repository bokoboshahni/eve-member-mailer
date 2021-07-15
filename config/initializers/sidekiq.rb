# frozen_string_literal: true

require 'sidekiq/throttled'
Sidekiq::Throttled.setup!

SidekiqAlive.setup do |config|
  config.server = 'puma'
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_QUEUE', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_QUEUE', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end
