class ApplicationController < ActionController::Base
  
  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end 
  
  private

  include SessionsHelper
  
  def require_user_logged_in
    unless logged_in?
      redirect_to root_url
    end
  end
  
  def counts(model)
    @count_posts = model.count
  end
  # def counts(user)
  #   @count_posts = user.posts.count
  #   @count_followings = user.followings.count
  #   @count_followers = user.followers.count
  # end
end
