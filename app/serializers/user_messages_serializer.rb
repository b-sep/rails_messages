# frozen_string_literal: true

class UserMessagesSerializer < ActiveModel::Serializer
  attributes :messages

  def messages
    {
      sended_messages: sended_messages,
      received_messages: received_messages
    }
  end

  private

  def received_messages
    object.received_messages.map do |message|
      {
        content: message.content,
        from: message.sender.name,
        received_at: I18n.l(message.created_at, format: :long)
      }
    end
  end

  def sended_messages
    object.sended_messages.map do |message|
      {
        content: message.content,
        sended_at: I18n.l(message.created_at, format: :long),
        to: message.recipient.name
      }
    end
  end
end
