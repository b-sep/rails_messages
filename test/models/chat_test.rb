# frozen_string_literal: true

require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  test 'all_chats_for scope returns all chats for user' do
    chat1 = chats(:one)
    chat2 = chats(:two)

    scope_result = Chat.all_chats_for(users(:john).id)

    assert_includes(scope_result, chat1)
    assert_includes(scope_result, chat2)
  end
end
