class ToppagesController < ApplicationController
  def index
    @posts = Post.all.page(params[:page])
    @prefectures = Prefecture.all
  end
  
  def detail
  end
end
