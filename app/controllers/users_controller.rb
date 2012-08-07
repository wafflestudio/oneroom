#encoding: utf-8
class UsersController < ApplicationController
  layout :choose_layout
  before_filter :require_session_json, :only => [:require_auth_token, :authorize]

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end

  public
  def new
    @user = User.new
    render '_new.html.erb'
  end

  def create
    @user = User.new(params[:user])

    if @user.valid?
      user = User.add_user(params[:user])

      if user
        session[:user] = user.id
        return_data('success', '가입 되었습니다.', user)
        return
      else
        return_data('error', '가입 과정에서 문제가 발생했습니다. 다시 시도해주세요.', nil)
        return
      end
    end

    return_data('error', '입력 내용이 유효하지 않습니다.', :model => @user.class.to_s.downcase, :errors => @user.errors)
  end

  def edit
    @user = User.find(params[:id])
    if @user.id == @session.id
      render '/users/_edit.html.erb'
    else
      render '/users/session/_edit.html.erb'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      return_data('success', '정보를 수정하였습니다.', @user)
      return
    else
      return_data('error', '입력 내용이 유효하지 않습니다.', :model => @user.class.to_s.downcase, :errors => @user.errors)
      return
    end
  end

  def destroy
  end

  def authorize
    user = User.find(params[:id])
    if user
      user.update_attribute(:authorized, user.auth_token == params[:token])
      if user.authorized
        return_data('success', '인증이 완료되었습니다!', nil)
      else
        return_data('error', '인증 과정에서 에러가 발생했습니다.', nil)
      end
    else
      return_data('error', '잘못된 접근입니다.', nil)
    end
  end

  def require_auth_token
    unless @session.email.end_with? "@snu.ac.kr"
      return_data('error', '서울대학교 학생만 인증하실 수 있습니다.', nil)
    else
      @session.generate_auth_token
      AuthMailer.send_auth_token(@session).deliver
      return_data('success', '메일이 전송되었습니다.', nil)
    end
  end
end
