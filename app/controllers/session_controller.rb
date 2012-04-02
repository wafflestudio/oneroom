class SessionController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end

  public
  def new
  end

  def create
  end

  def destroy
  end
end
