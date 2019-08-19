class PagesController < ApplicationController
  def home
    if logged_in?
      @pull_requests = PullRequest.joins(:pull_requests_tagged_users).preload(:user).preload(:users).preload(:pull_requests_tagged_users).where("pull_requests_tagged_users.user_id = ? AND pull_requests_tagged_users.status = ?", current_user.id, :active)
    end
  end
end
