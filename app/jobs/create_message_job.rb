# frozen_string_literal: true

class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(user_id, params)
    current_user = User.find(user_id)

    MessagesService.new(current_user:, params:).call
  end
end
