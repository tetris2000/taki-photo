class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def show
    @post = Post.find(params[:id])
    @post_comment = current_user.post_comments.build if logged_in?
    counts(@post.like_users)
  end
  
  def search
    @prefectures = Prefecture.all
    @posts = Post.search(params[:search])
    counts(@posts)
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    #load exif data from post.photo
    @post.save_exif
    
    if @post.save
      flash[:success] = "写真を投稿しました！"
      redirect_to @post
    else
      flash.now[:danger] = "投稿に失敗しました。"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      flash[:success] = "投稿内容を編集しました。"
      redirect_to @post
    else
      flash.now[:danger] = "投稿の編集に失敗しました。"
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_to @post.user
  end
  
  private
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
  
  def post_params
    params.require(:post).permit(:title, :photo, :explanation, :waterfall, :prefecture_id, :taken_at, :shutter_speed, :f_number, :iso, :focal_length, :camera, :use_exif)
  end

end