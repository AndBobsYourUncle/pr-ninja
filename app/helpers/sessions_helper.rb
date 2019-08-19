module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= if Rails.env.development?
      User.first
    else
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    return false unless current_user.present?

    unless Rails.env.development?
      begin
        current_user.slack_client.users_identity
      rescue Slack::Web::Api::Errors::SlackError => exception
        log_out
        return false
      end
    end

    true
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
