class RoomsController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['show', 'new'].include? action_name
      'room'
    end
  end

  public
  def index
    if params[:id]
      @rooms = Room.where(:_id => params[:id])
    else
      @rooms = Room.all
    end

    #TODO: select only needed info

    render :json => @rooms
  end

  def info
    @room = Room.find(params[:id])
    @room_info = @room.info
    if @session
      return_html('_info.html.erb')
    else
      return_html('_info_login.html.erb')
    end
  end

  def show
    @room = Room.find(params[:id])
    @room_info = @room.info
    @evaluations = @room.evaluations
    if @session
      render '_show.html.erb'
    else
      render '_show_login.html.erb'
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
