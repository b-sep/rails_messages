# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'should be invalid with blank content' do
    message = Message.new(
      content: nil,
      readed: false,
      sender: users(:john),
      recipient: users(:nodz)
    )

    assert_not message.valid?
    assert_includes message.errors[:content], 'can\'t be blank'
  end
end
