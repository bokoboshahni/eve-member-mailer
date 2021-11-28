# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  def rollout
    Rails.application.config.rollout
  end
end
