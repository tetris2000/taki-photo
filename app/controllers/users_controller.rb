class UsersController < ApplicationController
  
  def show
    set_user
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_url
    else
      flash.now[:danger] = "ユーザー登録に失敗しました。"
      render :new
    end
  end
  
  def edit
    set_user
  end
  
  def update
    set_user
    if @user.update(user_params)
      flash[:success] = "ユーザー設定を変更しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザー設定の変更に失敗しました。"
      render :edit
    end
  end
  
  def delete
    set_user
  end
  
  def destroy
    set_user
    @user.destroy
    
    redirect_to complete_url
  end
  
  def complete
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :introduction, :icon_photo)
  end
end

