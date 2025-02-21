# frozen_string_literal: true

class UserMessagesSerializer < ActiveModel::Serializer
  attributes :user, :messages

  def messages
    {
      sended_messages: sended_messages,
      received_messages: received_messages
    }
  end

  def user
    object.email_address
  end

  private

  def received_messages
    object.received_messages.map do |message|
      {
        content: message.content,
        received_at: I18n.l(message.created_at, format: :long)
      }
    end
  end

  def sended_messages
    object.sended_messages.map do |message|
      {
        content: message.content,
        sended_at: I18n.l(message.created_at, format: :long)
      }
    end
  end
end
