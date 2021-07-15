# frozen_string_literal: true

require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module EVEMemberMailer
  # The Rails application.
  class Application < Rails::Application
    DEFAULT_ESI_BASE_URL = 'https://esi.evetech.net'

    DEFAULT_ESI_API_SCOPES = %w[
      esi-corporations.read_corporation_membership.v1
      esi-mail.send_mail.v1
      publicData
    ].join(',')

    DEFAULT_ESI_USER_AGENT = 'EVE Member Mailer/1.0; (+https://github.com/bokoboshahni/eve-member-mailer)'

    config.x.esi.base_url = ENV['ESI_BASE_URL']
    config.x.esi.api_client_id = ENV['ESI_API_CLIENT_ID']
    config.x.esi.api_client_secret = ENV['ESI_API_CLIENT_SECRET']
    config.x.esi.api_scopes = ENV.fetch('ESI_API_SCOPES', DEFAULT_ESI_API_SCOPES).split(',').join(' ')
    config.x.esi.login_client_id = ENV['ESI_LOGIN_CLIENT_ID']
    config.x.esi.login_client_secret = ENV['ESI_LOGIN_CLIENT_SECRET']
    config.x.esi.user_agent = ENV.fetch('ESI_USER_AGENT', DEFAULT_ESI_USER_AGENT)

    config.x.emm.allowed_alliance_ids = ENV.fetch('EMM_ALLOWED_ALLIANCE_IDS', '').strip.split(',')
    config.x.emm.allowed_corporation_ids = ENV.fetch('EMM_ALLOWED_CORPORATION_IDS', '').strip.split(',')

    config.load_defaults 6.1

    config.generators.system_tests = nil
  end
end
