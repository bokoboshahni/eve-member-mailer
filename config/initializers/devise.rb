# frozen_string_literal: true

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.omniauth :api,
                  Rails.application.config.x.esi.api_client_id,
                  Rails.application.config.x.esi.api_client_secret,
                  strategy_class: OmniAuth::Strategies::EveOnlineSso,
                  scope: Rails.application.config.x.esi.api_scopes,
                  name: 'api'

  config.omniauth :login,
                  Rails.application.config.x.esi.login_client_id,
                  Rails.application.config.x.esi.login_client_secret,
                  strategy_class: OmniAuth::Strategies::EveOnlineSso,
                  name: 'login'
end
