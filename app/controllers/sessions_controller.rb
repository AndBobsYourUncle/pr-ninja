class SessionsController < ApplicationController
  def home
  end

  def create
    response = oauth_request

    user = find_or_create_user(response)

    log_in(user)

    redirect_to root_path
  end

  def destroy
    log_out

    redirect_to root_path
  end

  private

  def oauth_request
    # Instantiate a web client
    client = Slack::Web::Client.new

    # Request a token using the temporary code
    client.oauth_access(
      client_id: Settings.slack.client_id,
      client_secret: Settings.slack.client_secret,
      redirect_uri: "#{Settings.server_url}/login",
      code: params[:code]
    )
  end

  def find_or_create_user(response)
    user = User.find_or_create_by(slack_id: response['user']['id'])

    user.update!(
      name: response['user']['name'],
      slack_scopes: response['scope'].split(','),
      slack_team_id: response['team']['id'],
      slack_access_token: response['access_token']
    )

    user
  end
end
