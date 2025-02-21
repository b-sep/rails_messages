# frozen_string_literal: true

require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
  test 'POST /messages creates an message from to an user' do
    sender = users(:john)
    recipient = users(:nodz)

    login(sender)

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

  test 'POST /messages returns error if recipient isnt found' do
    sender = users(:john)

    login(sender)

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

  test 'GET /messages/:id return a json with messages from user' do
    Message.destroy_all
    user = users(:john)
    chat = chats(:one)
    sended_message = chat.messages.create!(user: user, content: 'Hi, i just sent that! :)')
    received_message = chat.messages.create!(user: users(:nodz), content: 'Hi, i just receive that! :)')

    login(user)

    get api_message_path(user), headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }

    assert_response :ok
    assert_equal(
      {
        user: user.id,
        messages: {
          sended_messages: [
            {
              content: sended_message.content,
              sended_at: I18n.l(sended_message.created_at, format: :long)
            }
          ],
          received_messages: [
            {
              content: received_message.content,
              received_at: I18n.l(received_message.created_at, format: :long)
            }
          ]
        }
      }, parsed_body
    )
  end

  test 'GET /messages/:id return 404 if user isnt found' do
    user = users(:john)

    login(user)

    get api_message_path('invalid'), headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }

    assert_response :not_found
  end

  test 'GET /messages/:id return 401 if user_id isnt from user logged' do
    user = users(:john)

    login(user)

    get api_message_path(users(:nodz)), headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }

    assert_response :unauthorized
  end

  private

  def login(user)
    post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                           params: { email_address: user.email_address, password: 'password' }
  end
end
