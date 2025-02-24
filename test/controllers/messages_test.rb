# frozen_string_literal: true

require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
  test 'POST /messages creates an message from to an user' do
    sender = users(:john)
    recipient = users(:nodz)

    login(sender)

    params = {
      message: {
        recipient: recipient.email_address,
        content: 'Hello, Nodz :)'
      }
    }

    post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last.token}" }, params: params
    assert_response :created
    assert_equal('Hello, Nodz :)', sender.sended_messages.last.content)
    assert_equal('Hello, Nodz :)', recipient.received_messages.last.content)
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
    assert_response :unprocessable_entity
    assert_equal({ error: 'Tem certeza que é esse o email?' }, parsed_body)
  end

  test 'POST /messages returns unauthorized if isnt log' do
    recipient = users(:nodz)

    params = {
      message: {
        recipient: recipient.email_address,
        content: 'Hello, Nodz :)'
      }
    }

    post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }, params: params
    assert_response :unauthorized
  end

  test 'POST /messages returns error if content is nil' do
    sender = users(:john)
    recipient = users(:nodz)

    login(sender)

    params = {
      message: {
        recipient: recipient.email_address,
        content: nil
      }
    }

    post api_messages_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last.token}" }, params: params
    assert_response :unprocessable_entity
    assert_equal({ error: 'Mensagem vazia não rola =/' }, parsed_body)
  end

  test 'GET /messages/:id return a json with messages from user' do
    user = users(:john)
    sended_message = user.sended_messages.last
    received_message = user.received_messages.last

    login(user)

    get api_message_path(user), headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last&.token}" }

    assert_response :ok
    assert_equal(
      {
        messages: {
          sended_messages: [
            {
              content: sended_message.content,
              sended_at: I18n.l(sended_message.created_at, format: :long),
              to: sended_message.recipient.name
            }
          ],
          received_messages: [
            {
              content: received_message.content,
              from: received_message.sender.name,
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
                           params: { email_address: user.email_address }
  end
end
