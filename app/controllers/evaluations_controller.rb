#encoding: utf-8
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

    if @session
      render '_new.html.erb'
    else
      return_data('error', '로그인이 필요합니다.', nil)
    end
  end

  def create
    @evaluation = Evaluation.new(params[:evaluation])

    if @evaluation.valid?
      ev = Evaluation.add_evaluation(params[:evaluation], @session, @room)
      if ev
        return_data('success', '평가가 저장되었습니다!', @evaluation)
        return
      else
        return_data('error', '저장 과정에서 문제가 발생하였습니다. 다시 시도해주세요.', nil)
        return
      end
    end

    return_data('error', '입력이 유효하지 않습니다.', :model => @evaluation.class.to_s.downcase, :errors => @evaluation.errors)
  end

  def update
  end

  def destroy
  end
end
