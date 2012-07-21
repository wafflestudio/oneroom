class RoomsController < ApplicationController
  layout :choose_layout
  before_filter :require_session_json, :only => [:search]

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
      render '/rooms/_show.html.erb'
    else
      render '/rooms/session/_show.html.erb'
    end
  end

  def new
    @room = Room.new
    @room.lat = params[:lat]
    @room.lng = params[:lng]

    render '_new.html.erb'
  end

  def create
    @room = Room.new(params[:room])

    if @room.valid?
      room = Room.add_room(params[:room])

      if room
        return_data('success', 'Room created', [room])
        return
      else
        return_data('error', 'Error occured on save', nil)
        return
      end
    end

    return_data('error', 'Input is not valid', nil)
  end

  def edit
    @room = Room.find(params[:id]) 

    render '_edit.html.erb'
  end

  def update
    @room = Room.find(params[:id]) 

    if @room.update_attributes(params[:room])
      return_data('success', 'Room updated', [@room])
      return
    else
      return_data('error', 'Error occured on update', nil)
      return
    end
  end

  def destroy
  end

  # INFO WINDOWS 
  def info
    @room = Room.find(params[:id])
    @room_info = @room.info
    if @session
      return_html('/rooms/_info.html.erb')
    else
      return_html('/rooms/session/_info.html.erb')
    end
  end

  def info_new
    if @session
      return_html('/rooms/_info_new.html.erb')
    else
      return_html('/rooms/session/_info_new.html.erb')
    end
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
