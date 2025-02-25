# frozen_string_literal: true

require 'test_helper'

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test 'connects with Authorization params' do
    user = users(:nodz)
    Session.create!(user_id: user.id, ip_address: '191.0.0.1', user_agent: 'Firefox', token: 'token')

    connect params: { 'Authorization' => 'token' }

    assert_equal(connection.current_user.id, user.id)
  end

  test 'rejects connection without params' do
    assert_reject_connection { connect }
  end

  test 'rejects connection if session isnt found' do
    assert_reject_connection do
      connect params: { 'Authorization' => 'token' }
    end
  end
end
