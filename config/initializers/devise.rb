# frozen_string_literal: true

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.omniauth :eve,
                  Rails.application.config.x.esi.client_id,
                  Rails.application.config.x.esi.client_secret,
                  strategy_class: OmniAuth::Strategies::EveOnlineSso,
                  name: 'eve'
end
