# frozen_string_literal: true

class MessagesService < BaseService
  private attr_accessor :current_user, :params

  def initialize(current_user:, params:) # rubocop:disable Lint/MissingSuper
    @current_user = current_user
    @params       = params
  end

  def call
    recipient = User.find_by(email_address: params[:recipient])

    return result(false, error: 'Recipient not found') unless recipient

    Message.create!(recipient:, sender: current_user, content: params[:content])

    result(true)
  end
end
