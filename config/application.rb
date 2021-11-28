# frozen_string_literal: true

require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module EVEMemberMailer
  class Application < Rails::Application
    DEFAULT_ESI_OAUTH_URL = 'https://login.eveonline.com'

    DEFAULT_ESI_SCOPES = %w[
      esi-mail.send_mail.v1
      esi-corporations.read_corporation_membership.v1
      esi-characters.read_corporation_roles.v1
    ].freeze

    DEFAULT_ESI_USER_AGENT = 'EVE Member Mailer/1.0; (+https://github.com/bokoboshahni/eve-member-mailer)'

    config.x.esi.client_id = ENV['ESI_CLIENT_ID']
    config.x.esi.client_secret = ENV['ESI_CLIENT_SECRET']
    config.x.esi.oauth_url = ENV.fetch('ESI_OAUTH_URL', DEFAULT_ESI_OAUTH_URL)
    config.x.esi.redirect_uri = ENV['ESI_REDIRECT_URI']
    config.x.esi.scopes = DEFAULT_ESI_SCOPES
    config.x.esi.user_agent = ENV.fetch('ESI_USER_AGENT', DEFAULT_ESI_USER_AGENT)

    config.x.emm.allowed_alliance_ids = ENV.fetch('EMM_ALLOWED_ALLIANCE_IDS', '').strip.split(',').map(&:to_i)
    config.x.emm.allowed_corporation_ids = ENV.fetch('EMM_ALLOWED_CORPORATION_IDS', '').strip.split(',').map(&:to_i)

    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq

    config.generators.system_tests = nil

    config.rollout = Rollout.new(Redis.new(url: ENV.fetch('REDIS_URL_FEATURES', 'redis://localhost:6379/2')),
                                 logging: { history_length: 100, global: true })

    config.slowpoke.timeout = lambda do |env|
      request = Rack::Request.new(env)
      path = request.path
      path.start_with?('/admin', '/auth') ? 15 : 5
    end

    config.middleware.insert_after ActionDispatch::RemoteIp, IpAnonymizer::MaskIp

    config.lograge.formatter = Lograge::Formatters::Json.new
  end
end
