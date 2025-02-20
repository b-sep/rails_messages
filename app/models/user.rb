# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :initiated_chats, class_name: 'Chat', foreign_key: 'initiator_id', dependent: :destroy
  has_many :received_chats, class_name: 'Chat', foreign_key: 'recipient_id', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_address, uniqueness: true
  validates :name, presence: true

  def received_messages
    chats = Chat.all_chats_for(id)

    Message.where(chat_id: chats.pluck(:id))
           .where.not(user_id: id)
           .order(created_at: :asc)
  end
end
