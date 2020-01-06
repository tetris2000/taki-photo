class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def show
    @post = Post.find(params[:id])
    @post_comment = current_user.post_comments.build if logged_in?
    counts(@post.like_users)
  end
  
  def search_for
  end
  
  def search
    @search_params = post_search_params
    @posts = Post.search_post(@search_params).order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def slow
    @posts = Post.slow_shutter.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def fast
    @posts = Post.fast_shutter.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def spring
    @posts = Post.spring.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def summer
    @posts = Post.summer.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def autumn
    @posts = Post.autumn.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def winter
    @posts = Post.winter.order(created_at: :desc).page(params[:page])
    search_function
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    # load exif data from post.photo (function defined at post.rb)
    # @post.photo==nilでは回避できなかった
    unless @post.photo.file == nil
      @post.save_exif
    end
    
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
  
  def search_function
    counts(@posts)
    # 一覧表示の都道府県別投稿数用
    @prefectures = Prefecture.all
  end
  
  def post_params
    params.require(:post).permit(:title, :photo, :explanation, :waterfall, :prefecture_id, :taken_at, :shutter_speed, :f_number, :iso, :focal_length, :camera, :use_exif)
  end
  
  def post_search_params
    params.fetch(:search_post, {}).permit(:prefecture_id, :waterfall, :shutter_speed_from, :shutter_speed_to, :f_number_from, :f_number_to , :focal_length_from, :focal_length_to, :camera, :taken_at_month_from, :taken_at_month_to, :taken_at_year_from, :taken_at_year_to)
  end

end