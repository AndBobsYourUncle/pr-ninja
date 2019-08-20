class UserTagsController < ApplicationController
  before_action :set_user_tag, only: [:mark_completed, :move]

  def mark_completed
    @user_tag.update!(status: :complete)

    redirect_to root_path
  end

  def move
    @user_tag.move_to! params[:position]
  end

  private

  def set_user_tag
    @user_tag = UserTag.find_by(id: params[:id], user_id: current_user.id)
  end
end
