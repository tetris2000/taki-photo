class ApplicationController < ActionController::Base
  private

  include SessionsHelper

  def require_user_logged_in
    unless logged_in?
      redirect_to root_url
    end
  end
  
  def counts(model)
    @count_posts = model.posts.count
  end
  # def counts(user)
  #   @count_posts = user.posts.count
  #   @count_followings = user.followings.count
  #   @count_followers = user.followers.count
  # end
end
