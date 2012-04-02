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

  def index    
  end

  def about
  end

  def contact
  end
end
