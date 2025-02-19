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

    private

    def message_params
      params.expect(message: %i[content recipient])
    end
  end
end
