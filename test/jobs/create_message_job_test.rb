# frozen_string_literal: true

require 'test_helper'

class CreateMessageJobTest < ActiveJob::TestCase
  test 'creates a message' do
    assert_difference('Message.count', +1) do
      user = users(:nodz)
      params = { recipient: users(:john).email_address, content: 'yay' }

      perform_enqueued_jobs do
        CreateMessageJob.perform_later(user.id, params)
      end
    end
  end
end
