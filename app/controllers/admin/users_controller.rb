#encoding: utf-8
class Admin::UsersController < Admin::ApplicationController
  layout 'admin'

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
 
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end


  def destroy

    redirect_to admin_users_path
  end

end
