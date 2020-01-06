class PostCommentsController < ApplicationController
  before_action :require_user_logged_in, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:create, :update]
  
  def create
    @post_comment = current_user.post_comments.build(post_comment_params)
    
    if @post_comment.save
      flash[:success] = "投稿にコメントしました！"
      redirect_to post_path(@post)
    else
      flash.now[:danger] = "コメントに失敗しました。"
      render "posts/show"
    end
  end

  def edit
    @post = Post.find(@post_comment.post_id)
  end

  def update
    if @post_comment.update(post_comment_params)
      flash[:success] = "コメントを編集しました！"
      redirect_to post_path(@post)
    else
      flash.now[:danger] = "コメント編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    @post_comment.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_comment][:post_id])
  end

  
  def correct_user
    @post_comment = current_user.post_comments.find_by(id: params[:id])
    unless @post_comment
      redirect_to root_url
    end
  end
  
  def post_comment_params
    params.require(:post_comment).permit(:user_id, :post_id, :comment)
  end
end
