# frozen_string_literal: true

Rack::Attack.throttle('logins/ip', limit: 20, period: 1.hour) do |req|
  req.ip if req.post? && req.path.start_with?('/auth/eve')
end

ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  Rails.logger.info "Throttled #{req.env['rack.attack.match_discriminator']}"
end
