# frozen_string_literal: true

Rollout::UI.configure do
  instance { Rails.application.config.rollout }
  actor { current_user&.username }
  actor_url { |actor| "/admin/users/#{actor}" }
end
