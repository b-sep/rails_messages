# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    resource :session, only: %i[create destroy]

    resources :messages, only: %i[create show]
  end

  mount Sidekiq::Web => '/sidekiq'
end
