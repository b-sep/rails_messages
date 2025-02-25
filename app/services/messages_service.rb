# frozen_string_literal: true

class MessagesService < BaseService
  private attr_accessor :current_user, :params

  def initialize(current_user:, params:) # rubocop:disable Lint/MissingSuper
    @current_user = current_user
    @params       = params
  end

  def call
    recipient = User.find_by(email_address: params[:recipient])

    return result(false, error: 'Tem certeza que é esse o email?') unless recipient

    message = Message.create!(recipient:, sender: current_user, content: params[:content])

    broadcast_messages(message, recipient)

    result(true)
  rescue ActiveRecord::RecordInvalid => _e
    result(false, error: 'Mensagem vazia não rola =/')
  end

  private

  def broadcast_messages(message, recipient)
    created_at = I18n.l(message.created_at, format: :long)
    content = message.content

    ActionCable.server.broadcast(
      "message_#{current_user.id}",
      { type: 'sended', message: { content:, to: recipient.name, sended_at: created_at } }
    )

    ActionCable.server.broadcast(
      "message_#{recipient.id}",
      { type: 'received', message: { content:, from: current_user.name, received_at: created_at } }
    )
  end
end
