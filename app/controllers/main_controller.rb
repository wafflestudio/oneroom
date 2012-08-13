#encoding: utf-8
class MainController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['index'].include? action_name
      'application'
    else
      'tooltip'
    end
  end

  public
  def index   
    @room_size = Room.all.length
    @eval_size = Evaluation.all.length
  end

  def contact
    ContactMailer.send_contact_mail(params[:contact]).deliver
    return_data("success", "메일을 전송하였습니다.", nil)
  end
end
