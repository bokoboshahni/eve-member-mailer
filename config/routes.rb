# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  authenticate :user, ->(u) { u.admin? } do
    mount PgHero::Engine => '/admin/postgres'
    mount Rollout::UI::Web.new => '/admin/rollout'
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  scope format: false do # rubocop:disable Metrics/BlockLength
    get '/healthz', to: 'health#show', as: :health

    get '/dashboard', to: 'dashboard#index'

    resources :broadcasts do
      member do
        delete :trash, to: 'broadcasts#discard'
      end

      resource :schedule, only: %i[new create], controller: :broadcast_scheduling
    end

    resources :campaigns do
      member do
        delete :trash, to: 'campaigns#discard'
      end

      resources :deliveries, controller: 'campaign_deliveries', only: %i[index show]
      resources :steps, controller: 'campaign_steps'
      resources :memberships, controller: 'campaign_memberships'
      resources :triggers, controller: 'campaign_triggers'
    end

    resources :deliveries, only: %i[index show]

    resources :lists do
      resources :conditions, controller: 'list_conditions' do
        patch :reorder
      end

      resources :memberships, controller: 'list_memberships'
    end

    resources :templates do
      member do
        delete '/trash', to: 'templates#discard'
      end

      resource :test, only: %i[new create], controller: 'template_tests'
    end

    resources :reports

    resource :settings, only: %i[show update]
    resources :character_settings, path: 'settings/characters'

    root to: 'landing#index'
  end

  devise_for :user, path: '', controllers: { omniauth_callbacks: 'authentications' }
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
end
