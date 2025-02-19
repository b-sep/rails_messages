# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def setup
    @session = Session.new(
      user: users(:john),
      ip_address: '192.168.1.1',
      token: 'randomtoken123',
      user_agent: 'Mozilla/5.0'
    )
  end

  test 'valid session' do
    assert @session.valid?
  end

  test 'invalid without ip_address' do
    @session.ip_address = nil
    assert_not @session.valid?
    assert_includes @session.errors[:ip_address], "can't be blank"
  end

  test 'invalid without token' do
    @session.token = nil
    assert_not @session.valid?
    assert_includes @session.errors[:token], "can't be blank"
  end

  test 'invalid without user_agent' do
    @session.user_agent = nil
    assert_not @session.valid?
    assert_includes @session.errors[:user_agent], "can't be blank"
  end
end
