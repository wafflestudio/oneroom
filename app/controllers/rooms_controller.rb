#encoding: utf-8
class RoomsController < ApplicationController
  layout :choose_layout
  before_filter :require_session_json, :only => [:search]

  private
  def choose_layout
    if ['show', 'edit'].include? action_name
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
    @evaluations = @room.evaluations.page(params[:page])
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
        return_data('success', '방 정보를 생성하였습니다.', [room])
        return
      else
        return_data('error', '생성 과정에서 문제가 발생했습니다. 다시 시도해주세요.', nil)
        return
      end
    end

    return_data('error', '입력 내용이 유효하지 않습니다.', nil)
  end

  def edit
    @room = Room.find(params[:id]) 
    @room_info = @room.info

    render '_edit.html.erb'
  end

  def update
    @room = Room.find(params[:id]) 

    if @room.update_attributes(params[:room])
      return_data('success', '정보를 수정하였습니다.', [@room])
      return
    else
      return_data('error', '수정 과정에서 문제가 발생했습니다. 다시 시도해주세요.', nil)
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
      return_data('error', '검색 결과가 없습니다.', nil)
    end
  end
end
