# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    resource :session, only: %i[create destroy]

    post 'messages', to: 'messages#create'
  end
end
