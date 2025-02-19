# frozen_string_literal: true

require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test 'POST /api/session creates a session to user if password is valid' do
    assert_difference('Session.count', +1) do
      user = users(:john)

      post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                             params: { email_address: user.email_address, password: 'password' }

      assert_response :created
      assert_equal({ token: Session.last.token }, parsed_body)
    end
  end

  test 'POST /api/session returns unauthorized if password is wrong' do
    user = users(:john)

    post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                           params: { email_address: user.email_address, password: 'wrong' }

    assert_response :unauthorized
    assert_equal({ error: 'Try again' }, parsed_body)
  end

  test 'DELETE /api/session destroys session' do
    user = users(:john)

    post api_session_path, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' },
                           params: { email_address: user.email_address, password: 'password' }

    delete api_session_path, headers: { HTTP_AUTHORIZATION: "Bearer #{Session.last.token}" }

    assert_response :no_content
    assert_equal([], user.sessions)
  end
end
