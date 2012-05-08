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
    render :json => {'html' => render_to_string('new.html.erb')}
  end

  def create
  end

  def show
    render :json => {'html' => render_to_string('_show.html.erb')}
  end

  def destroy
  end
end
