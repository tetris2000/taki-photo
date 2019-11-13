class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def show
    @post = Post.find(params[:id])
    @post_comment = current_user.post_comments.build if logged_in?
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    require "exifr/jpeg"
    @post.taken_at = EXIFR::JPEG.new(@post.photo.file.file).date_time
    @post.shutter_speed = EXIFR::JPEG.new(@post.photo.file.file).exposure_time
    @post.f_number = EXIFR::JPEG.new(@post.photo.file.file).f_number
    @post.iso = EXIFR::JPEG.new(@post.photo.file.file).iso_speed_ratings
    @post.focal_length = EXIFR::JPEG.new(@post.photo.file.file).focal_length
    @post.camera = EXIFR::JPEG.new(@post.photo.file.file).model
    
    if @post.save
      binding.pry
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