# frozen_string_literal: true

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test 'should enforce uniqueness of user per chat' do
    user = User.create!(email_address: 'email@beto.com', name: 'Beto', password_digest: 'password')

    Conversation.create!(user:, chat: chats(:one))

    conversation = Conversation.new(user:, chat: chats(:one))

    assert_not conversation.valid?
    assert_includes conversation.errors[:user_id], 'has already been taken'
  end
end
