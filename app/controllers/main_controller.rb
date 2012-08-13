class MainController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['index'].include? action_name
      'application'
    else
      'tooltip'
    end
  end

  public
  def index   
    @room_size = Room.all.length
    @eval_size = Evaluation.all.length
  end

  def about
  end

  def contact
  end
end
