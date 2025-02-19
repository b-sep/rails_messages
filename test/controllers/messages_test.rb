# frozen_string_literal: true

require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
  setup { Chat.destroy_all }

  test 'POST /messages find or create a chat and send message to it' do
    assert_difference('Chat.count', +1) do
      sender = users(:john)
      recipient = users(:nodz)

      # logs in
      post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                             params: { email_address: sender.email_address, password: 'password' }

      params = {
        message: {
          recipient: recipient.id,
          content: 'Hello, Nodz :)'
        }
      }

      post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last.token}" }, params: params
      assert_response :created
      assert_equal('Hello, Nodz :)', sender.messages.last.content)
      assert_equal('Hello, Nodz :)', recipient.received_chats.last.messages.last.content)
    end
  end

  test 'POST /messages returns error if recipient isnt found' do
    sender = users(:john)

    # logs in
    post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                           params: { email_address: sender.email_address, password: 'password' }

    params = {
      message: {
        recipient: 'invalid',
        content: 'Hello, Nodz :)'
      }
    }

    post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last.token}" }, params: params
    assert_response :bad_request
  end

  test 'POST /messages returns unauthorized if isnt log' do
    recipient = users(:nodz)

    params = {
      message: {
        recipient: recipient.id,
        content: 'Hello, Nodz :)'
      }
    }

    post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }, params: params
    assert_response :unauthorized
    assert_equal({ error: 'Please log in' }, parsed_body)
  end
end
