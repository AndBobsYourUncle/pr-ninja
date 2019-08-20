class PullRequest < ApplicationRecord
  belongs_to :user
  has_many :user_tags
  has_many :tagged_users, through: :user_tags, source: :user
end
