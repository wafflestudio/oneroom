class EvaluationsController < ApplicationController
  layout :choose_layout

  before_filter :init_room

  private
  def choose_layout
    if ['new'].include? action_name
      'room'
    end
  end

  def init_room
    @room = Room.find(params[:room_id]) 
    @room_info = @room.info
  end

  public
  def index
    #TODO: Filtering Index
    #TODO: Return as JSON
  end

  def new
    @evaluation = Evaluation.new
    render '_new.html.erb'
  end

  def create
    @evaluation = Evaluation.new(params[:evaluation])

    if @evaluation.valid?
      ev = Evaluation.add_evaluation(params[:evaluation], @session, @room)
      if ev
        return_data('success', 'Your evaluation submitted', @evaluation)
        return
      else
        return_data('error', 'Input is not valid', nil)
        return
      end
    end

    return_data('error', 'Error Occurred on save', @evaluation.errors)
  end

  def update
  end

  def destroy
  end
end
