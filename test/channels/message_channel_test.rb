# frozen_string_literal: true

require "test_helper"

class MessageChannelTest < ActionCable::Channel::TestCase
  test 'subscribes and stream for user' do
    user = users(:nodz)

    subscribe(user_id: user.id)

    assert subscription.confirmed?
    assert_has_stream "message_#{user.id}"
  end
end
