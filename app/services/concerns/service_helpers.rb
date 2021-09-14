# frozen_string_literal: true

# Helpers for services.
module ServiceHelpers
  extend ActiveSupport::Concern

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ESIHelpers

  protected

  def cache
    Rails.cache
  end

  def config
    Rails.application.config
  end

  def emm
    config.x.emm
  end

  def logger
    Rails.logger
  end

  def redis
    emm.redis
  end

  def rollout
    config.rollout
  end
end
