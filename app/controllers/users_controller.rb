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
    render :json => {'status' => 'error'}
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
