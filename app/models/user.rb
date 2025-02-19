# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_address, uniqueness: true
  validates :name, presence: true
end
