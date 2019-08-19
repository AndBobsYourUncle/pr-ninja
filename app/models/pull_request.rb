class PullRequest < ApplicationRecord
  belongs_to :user
  has_many :pull_requests_tagged_users
  has_many :users, through: :pull_requests_tagged_users

  def tagged_user(user)
    self.pull_requests_tagged_users.select { |prtu| prtu.user_id == user.id }.first
  end
end
