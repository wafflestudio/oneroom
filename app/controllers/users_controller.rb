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
        return_data('error', 'Input is not valid', nil)
        return
      end
    end

    return_data('error', 'Error Occurred on save', nil)
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
