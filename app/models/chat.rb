# frozen_string_literal: true

class Chat < ApplicationRecord
  has_many :conversations, dependent: :destroy
  has_many :users, through: :conversations
  has_many :messages, dependent: :destroy
end
