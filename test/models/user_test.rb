# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should have a valid email' do
    user = User.new(email_address: 'invalid')

    assert_predicate(user, :invalid?)
    assert_equal(['Email address is invalid'], user.errors.full_messages_for(:email_address))
  end

  test 'email address should be unique' do
    user = User.new(email_address: users(:john).email_address)

    assert_predicate(user, :invalid?)
    assert_equal(['Email address has already been taken'], user.errors.full_messages_for(:email_address))
  end

  test 'should have a name' do
    user = User.new(email_address: 'email@example.com')

    assert_predicate(user, :invalid?)
    assert_equal(['Name can\'t be blank'], user.errors.full_messages_for(:name))
  end

  test '#received_messages' do
    user = users(:john)
    chat = chats(:one)
    sended_message = chat.messages.create!(user: user, content: 'Hi, i just sent that! :)')
    received_message = chat.messages.create!(user: users(:nodz), content: 'Hi, i just receive that! :)')

    assert_includes(user.received_messages, received_message)
    refute_includes(user.received_messages, sended_message)
  end
end
