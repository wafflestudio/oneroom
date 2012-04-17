class RoomsController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['show', 'new', 'update'].include? action_name
      'tooltip'
    end
  end

  public
  def index
    if params[:id]
      @rooms = Room.where(:_id => params[:id])
    else
      @rooms = Room.all
    end

    render :json => @rooms
  end

  def info
    @room = Room.find(params[:id])
    render :json => {'html' => render_to_string('info.html.erb')}
  end

  def show
    @room = Room.find(params[:id])    
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
