# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :user_id, uniqueness: { scope: :chat_id }
end
