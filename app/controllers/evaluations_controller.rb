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

  def evaluate
    @evaluation = Evaluation.find(params[:id])

    if @evaluation.user.id == @session.id
      return_data('error', '자신의 평가는 평가할 수 없습니다.', @evaluation)
      return
    end

    if @evaluation.agree.include? @session.id or @evaluation.disagree.include? @session.id
      return_data('error', '이미 평가하셨습니다.', @evaluation)
      return
    end

    if params[:evaluate] == "agree"
      @evaluation.agree << @session.id
    else params[:evaluate] == "disagree"
      @evaluation.disagree << @session.id
    end

    if @evaluation.save
      return_data('success', '평가 완료되었습니다.', @evaluation)
    else
      return_data('error', '평가 과정에서 문제가 발생했습니다. 다시 시도해주세요.', @evaluation)
    end
  end
end
