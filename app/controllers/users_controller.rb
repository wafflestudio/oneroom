class UsersController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.valid?
      user = User.add_user(params[:user])

      if user
        session[:user] = user.id
        render :json => {'status' => 'success', 'msg' => 'User created.', 'data' => user}
        return
      else
        render :json => {'status' => 'error', 'msg' => "Input is not valid."}
        return
      end
    end

    render :json => {'status' => 'error', 'msg' => "Error Occurred on save."}
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
