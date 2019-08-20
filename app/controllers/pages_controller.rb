class PagesController < ApplicationController
  def home
    if logged_in?
      @tagged_prs = PullRequestsTaggedUser.where(user_id: current_user.id, status: :active).preload(pull_request: [:user, :users]).ordered_by_position_asc
    end
  end

  def completed
    if logged_in?
      @tagged_prs = PullRequestsTaggedUser.where(user_id: current_user.id, status: :complete).preload(pull_request: [:user, :users]).ordered_by_position_asc
    end
  end
end
