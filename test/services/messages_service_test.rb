# frozen_string_literal: true

require 'test_helper'

class MessagesServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  test '#call creates a message if params are valid' do
    assert_difference('Message.count', +1) do
      user = users(:nodz)
      recipient = users(:john)
      params = { recipient: recipient.email_address, content: 'Yay' }
      instance = MessagesService.new(current_user: user, params:)

      result = instance.call

      assert_broadcasts "message_#{user.id}", 1
      assert_broadcasts "message_#{recipient.id}", 1
      assert result.success?
      assert_nil result.error
    end
  end

  test '#call returns result as false if recipient isnt found' do
    params = { recipient: 'invalid', content: 'Yay' }
    instance = MessagesService.new(current_user: User.new, params:)

    result = instance.call

    refute result.success?
    assert_equal('Tem certeza que é esse o email?', result.error)
  end

  test '#call returns result as false and error if content is empty' do
    params = { recipient: users(:nodz).email_address, content: '' }
    instance = MessagesService.new(current_user: User.new, params:)

    result = instance.call

    refute result.success?
    assert_equal('Mensagem vazia não rola =/', result.error)
  end
end
