class User < ApplicationRecord
  has_many :pull_requests_tagged_users, -> { ordered_by_position_asc }
  accepts_nested_attributes_for :pull_requests_tagged_users

  def slack_client
    @slack_client ||= Slack::Web::Client.new(token: self.slack_access_token)
  end

  def display_name
    self.name || "Unknown (#{self.slack_id})"
  end
end
