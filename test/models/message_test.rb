# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'should be invalid with blank content' do
    message = Message.new(
      chat: chats(:one),
      user: users(:john),
      content: nil,
      readed: false
    )

    assert_not message.valid?
    assert_includes message.errors[:content], 'can\'t be blank'
  end

  test 'ordered scope should return messages in chronological order' do
    older_message = Message.create(
      chat: chats(:one),
      user: users(:john),
      content: 'Hello from yesterday',
      created_at: 1.day.ago
    )

    newer_message = Message.create(
      chat: chats(:one),
      user: users(:john),
      content: 'Hello from today',
      created_at: 1.hour.from_now
    )

    scope_result = Message.chat_messages(chats(:one).id)

    assert_equal older_message, scope_result.first
    assert_equal newer_message, scope_result.last
  end
end
