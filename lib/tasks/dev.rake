# frozen_string_literal: true

require 'rails/dev_lograge'

namespace :dev do
  desc 'Toggle lograge in dev'
  task lograge: :environment do
    Rails::DevLograge.enable_by_file
  end
end
