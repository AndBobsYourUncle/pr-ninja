class User < ApplicationRecord
  def slack_client
    @slack_client ||= Slack::Web::Client.new(token: self.slack_access_token)
  end

  def display_name
    self.name || "Unknown (#{self.slack_id})"
  end
end
