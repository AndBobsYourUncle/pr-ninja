class PullRequest < ApplicationRecord
  belongs_to :user
  has_many :user_tags
  has_many :users, through: :user_tags
end
