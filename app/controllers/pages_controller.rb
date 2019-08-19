class PagesController < ApplicationController
  def home
    if logged_in?
      @pull_requests = PullRequest.joins(:users).preload(:user).preload(:users).where("users.id = ?", current_user.id)
    end
  end
end
