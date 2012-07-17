class RoomsController < ApplicationController
  layout :choose_layout
  before_filter :require_session_json, :only => [:new, :search]

  private
  def choose_layout
    if ['show'].include? action_name
      'room'
    else
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

    #TODO: select only needed info

    return_data('success', nil, @rooms)
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
    @room = Room.new
    render '_new.html.erb'
  end

  def create
  end

  def edit
    
  end

  def update
  end

  def destroy
  end

  # INFO WINDOWS 
  def info
    @room = Room.find(params[:id])
    @room_info = @room.info
    if @session
      return_html('_info.html.erb')
    else
      return_html('_info_login.html.erb')
    end
  end

  def info_new
    return_html('_info_new.html.erb')
  end

  # SEARCH ROOMS!
  def search
    @rooms = Room.search(params)

    if @rooms.length > 0
      return_data_and_html('success', nil, @rooms, render_to_string('_search.html.erb'))
    else
      return_data('error', 'No room found', nil)
    end
  end
end
