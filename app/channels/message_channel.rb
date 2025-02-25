# frozen_string_literal: true

class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
