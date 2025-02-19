# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true

  scope :chat_messages, ->(chat_id) { where(chat_id: chat_id).order(created_at: :asc) }
end
