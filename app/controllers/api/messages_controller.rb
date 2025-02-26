# frozen_string_literal: true

module Api
  class MessagesController < ApplicationController
    def create
      CreateMessageJob.perform_later(Current.user.id, message_params.to_h)

      head :ok
    end

    def show
      user = User.find_by(id: params[:id])

      return head :not_found unless user
      return head :unauthorized unless user == Current.user

      render json: UserMessagesSerializer.new(user).as_json, status: :ok
    end

    private

    def message_params
      params.expect(message: %i[content recipient]).tap do |params|
        params.expect(:content)
        params.expect(:recipient)
      end
    end
  end
end
