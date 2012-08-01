class UsersController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end
  
  public
  def new
    @user = User.new
    render '_new.html.erb'
  end

  def create
    @user = User.new(params[:user])

    if @user.valid?
      user = User.add_user(params[:user])

      if user
        session[:user] = user.id
        return_data('success', 'User created', user)
        return
      else
        return_data('error', 'Error occurred on save', nil)
        return
      end
    end

    return_data('error', 'Input is not valid', nil)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def authorize
    user = User.find(params[:id])
    if user
      user.update_attribute(:authorized, user.auth_token == params[:token])
      if user.authorized
        flash[:success] = "Authorized"
      else
        flash[:error] = "Cannot authorize user"
      end
    else
      flash[:error] = "Cannot find user"
    end
    redirect_to root_path
  end

  def require_auth_token
    if @session
      unless @session.email.end_with? "@snu.ac.kr"
        render :text => "You're not SNU student"
      else
        @session.generate_auth_token
        AuthMailer.send_auth_token(@session).deliver
        render :text => "authorization email sent"
      end
    else
      #TODO : error 처리
      render :text => "You're not logged in"
    end
  end
end
