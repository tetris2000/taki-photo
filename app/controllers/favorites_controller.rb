class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    pst = Post.find(params[:post_id])
    current_user.like(pst)
    flash[:success] = "投稿をお気に入りしました！"
    redirect_back(fallback_location: root_url)
  end

  def destroy
    pst = Post.find(params[:post_id])
    current_user.dislike(pst)
    flash[:success] = "お気に入りを解除しました。"
    redirect_back(fallback_location: root_url)
  end
end
