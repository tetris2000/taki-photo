class ToppagesController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page])
    @prefectures = Prefecture.all
  end
  
  def detail
  end
end
