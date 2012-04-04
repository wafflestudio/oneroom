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
    @rooms = Room.all
    render :json => @rooms
  end

  def show
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
