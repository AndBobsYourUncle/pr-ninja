class UserTagsController < ApplicationController
  before_action :set_user_tag, only: [:mark_complete, :mark_active]

  def mark_complete
    @user_tag.update_status!(:complete)

    redirect_back fallback_location: root_path
  end

  def mark_active
    @user_tag.update_status!(:active)

    redirect_back fallback_location: root_path
  end

  def move
    @user_tag.move_to! params[:position]
  end

  private

  def set_user_tag
    @user_tag = UserTag.find_by(id: params[:id], user_id: current_user.id)
  end
end
