# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  authenticate :user, ->(u) { u.admin? } do
    mount PgHero::Engine => '/admin/postgres'
    mount Rollout::UI::Web.new => '/admin/rollout'
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :admin do
    resources :alliances, only: %i[index show destroy]
    resources :characters, only: %i[index show destroy]
    resources :corporations, only: %i[index show destroy]
    resources :deliveries, only: %i[index show destroy]
    resources :users

    root to: 'dashboard#index'
  end

  devise_for :user, path: '', controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    delete 'auth/logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get '/healthz', to: 'health#show', as: :health

  get '/dashboard', to: 'dashboard#index'

  resources :characters, only: %i[index show] do
    resources :progressions, only: %i[index show]
  end

  resources :corporations, only: %i[index show edit update], path_names: { edit: 'settings' } do
    resources :authorizations, only: %i[index destroy update], controller: :corporation_authorizations
    resources :members, only: %i[index], controller: :corporation_members
  end

  resources :series do
    member do
      delete :trash
      put :pause
      put :start
    end

    resources :steps, controller: :series_steps do
      member do
        put :move
      end
    end

    resources :subscriptions, controller: :series_subscriptions, only: %i[index show]
  end

  resource :user, path: 'settings', only: %i[show update destroy] do
    resources :characters, only: %i[index create update destroy], controller: :user_characters
  end

  root to: 'landing#index'
end
