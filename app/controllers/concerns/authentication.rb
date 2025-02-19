# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    after_action :refresh_session, unless: -> { Rails.env.local? }
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def require_authentication
    resume_session || render_unauthorized
  end

  def resume_session
    token = request.headers['Authorization']&.split(/\s/)&.last

    Current.session ||= Session.find_by(token: token)
  end

  def render_unauthorized
    render json: { error: 'Please log in' }, status: :unauthorized
  end

  def start_new_session_for(user)
    # https://ruby-doc.org/stdlib-2.5.0/libdoc/securerandom/rdoc/Random/Formatter.html#method-i-urlsafe_base64
    session_token = SecureRandom.urlsafe_base64(32)

    user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip,
      token: session_token
    ).tap do |session|
      Current.session = session
    end
  end

  def refresh_session
    session = Current.session
    return unless session

    session.update!(token: SecureRandom.urlsafe_base64(32))
    response.set_header('Authorization', "Bearer #{session.token}")
  end

  def terminate_session
    Current.session.destroy
  end
end
