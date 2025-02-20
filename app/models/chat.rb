# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :messages, dependent: :destroy

  scope :all_chats_for, ->(user_id) { where(initiator_id: user_id).or(where(recipient_id: user_id)) }
end
