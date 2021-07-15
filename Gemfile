# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'dotenv-rails', groups: %i[development test]

gem 'ancestry', '~> 4.1'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.8'
gem 'discard', '~> 1.2'
gem 'faraday', '~> 1.4'
gem 'faraday-http-cache', '~> 2.2'
gem 'faraday_middleware', '~> 1.0'
gem 'hiredis', '~> 0.6'
gem 'liquid', '~> 5.0'
gem 'local_time', '~> 2.1'
gem 'lockbox', '~> 0.6'
gem 'nanoid', '~> 2.0'
gem 'oauth2', '~> 1.4'
gem 'omniauth', '~> 2.0'
gem 'omniauth-eve_online-sso', '~> 0.2'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'pagy', '~> 4.10'
gem 'paper_trail', '~> 12.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.3'
gem 'pundit', '~> 2.1'
gem 'rails', '~> 6.1.3'
gem 'rails-pg-extras', '~> 2.0'
gem 'redis', '~> 4.2'
gem 'redis-namespace', '~> 1.8'
gem 'retriable', '~> 3.1.2'
gem 'sidekiq', '~> 6.2'
gem 'sidekiq_alive', '~> 2.0'
gem 'sidekiq-batch', '~> 0.1'
gem 'sidekiq-scheduler', '~> 3.1'
gem 'sidekiq-status', '~> 2.0'
gem 'sidekiq-throttled', '~> 0.13'
gem 'sidekiq-unique-jobs', '~> 7.1'
gem 'spring', require: false
gem 'tty-progressbar', require: false
gem 'validates_timeliness', '~> 5.0'
gem 'validate_url', '~> 1.0'
gem 'webpacker', '~> 5.4'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate', require: false
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'listen', '~> 3.5'
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'rubocop', require: false
  gem 'rubocop-faker', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'solargraph', require: false
  gem 'spring-commands-rspec', require: false
  gem 'spring-commands-rubocop', require: false
  gem 'spring-watcher-listen', require: false
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', require: false
  gem 'rotp', require: false
  gem 'selenium-webdriver', require: false
  gem 'simplecov', require: false
  gem 'simplecov_json_formatter', require: false
  gem 'site_prism', require: false
  gem 'timecop', require: false
  gem 'vcr', require: false
  gem 'webmock', require: false
end
