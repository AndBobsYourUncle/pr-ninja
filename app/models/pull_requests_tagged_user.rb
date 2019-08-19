class PullRequestsTaggedUser < ApplicationRecord
  belongs_to :user
  belongs_to :pull_request

  enum status: { active: 0, complete: 1 }
end
