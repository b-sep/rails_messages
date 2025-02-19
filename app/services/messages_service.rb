# frozen_string_literal: true

class MessagesService < BaseService
  private attr_accessor :current_user, :params

  def initialize(current_user:, params:)
    @current_user = current_user
    @params       = params
  end

  def call
    chat = find_or_init_chat

    return result(false, error: 'Recipient not found') unless chat

    chat.messages.create!(user: current_user, content: params[:content])

    result(true)
  end

  private

  def find_or_init_chat
    recipient = User.find_by(id: params[:recipient])

    return unless recipient

    current_user.initiated_chats.find_or_create_by!(recipient:)
  end
end
