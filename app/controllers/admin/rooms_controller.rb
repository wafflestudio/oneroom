#encoding: utf-8
class Admin::RoomsController < Admin::ApplicationController
  layout 'admin'

  def index
    @rooms = Room.all

  end

  def show
    @room = Room.find(params[:id])
  end
 
  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(params[:room])
      redirect_to admin_room_path(@room)
    else
      render :edit
    end
  end

  def destroy

    redirect_to admin_rooms_path
  end
end
