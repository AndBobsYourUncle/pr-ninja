class PullRequestsTaggedUsersController < ApplicationController
  before_action :set_pull_requests_tagged_user, only: [:mark_completed, :move]

  def mark_completed
    @pull_requests_tagged_user.update!(status: :complete)

    redirect_to root_path
  end

  def move
    @pull_requests_tagged_user.move_to! params[:position]
  end

  private

  def set_pull_requests_tagged_user
    @pull_requests_tagged_user = PullRequestsTaggedUser.find_by(id: params[:id], user_id: current_user.id)
  end
end
