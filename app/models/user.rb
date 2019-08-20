class User < ApplicationRecord
  has_many :user_tags, -> { ordered_by_position_asc }

  def slack_client
    @slack_client ||= Slack::Web::Client.new(token: self.slack_access_token)
  end

  def display_name
    self.name || "Unknown (#{self.slack_id})"
  end
end
