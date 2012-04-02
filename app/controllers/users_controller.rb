class UsersController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
