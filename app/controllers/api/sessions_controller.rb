# frozen_string_literal: true

module Api
  class SessionsController < ApplicationController
    allow_unauthenticated_access only: %i[create]
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { head :no_content }

    def create
      if user = User.find_by(email_address: params[:email_address])
        session = start_new_session_for(user)

        render json: { token: session.token }, status: :created
      else
        head :unauthorized
      end
    end

    def destroy
      terminate_session

      head :no_content
    end
  end
end
