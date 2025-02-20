# frozen_string_literal: true

module Api
  class MessagesController < ApplicationController
    def create
      res = MessagesService.new(current_user: Current.user, params: message_params).call

      case res.success?
      in false then head :bad_request
      in true then head :created
      end
    end

    def show
      user = User.find_by(id: params[:id])

      return head :not_found unless user
      return head :unauthorized unless user == Current.user

      render json: UserMessagesSerializer.new(user).as_json, status: :ok
    end

    private

    def message_params
      params.expect(message: %i[content recipient])
    end
  end
end
