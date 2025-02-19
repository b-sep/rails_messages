# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  validates :ip_address, :token, :user_agent, presence: true
end
