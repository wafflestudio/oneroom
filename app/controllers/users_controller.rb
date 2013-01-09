#encoding: utf-8
class UsersController < ApplicationController
  layout :choose_layout
  before_filter :require_session_json, :only => [:require_auth_token]

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
        user.generate_auth_token
        AuthMailer.send_auth_token(user).deliver

        return_data('success', '가입 되었습니다. 메일을 통해 인증을 마무리해주세요.', user)
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
    
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.user_save_password

    if @user.save
      return_data('success', '정보를 수정하였습니다.', nil)
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
        session[:user] = user.id
        @session = user

      end
    end

    redirect_to root_path
  end

  def reauthorize
    @user = User.new
    render '_reauthorize.html.erb'
  end

  def do_reauthorize
    @user = User.where(:username => params[:user][:username], :email => params[:user][:email]).first

    if @user
      if @user.authorized
        return_data('error', '이미 인증된 회원입니다.', nil)
        return        
      else
        @user.generate_auth_token
        AuthMailer.send_auth_token(@user).deliver
        return_data('success', '인증 메일을 전송하였습니다.', nil)
        return
      end
    end

    return_data('error', '해당되는 유저가 없습니다.', nil)

  end


  def find_password
    @user = User.new
    render '_find_password.html.erb'
  end

  def reset_password
    @user = User.where(:username => params[:user][:username], :email => params[:user][:email]).first

    if @user
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      new_password = Array.new(10) { chars[rand(chars.size-1)] }.join("").to_s
      @user.password = new_password
      @user.user_save_password

      if @user.save
        AuthMailer.send_new_password(@user, new_password).deliver
        return_data('success', '새로운 비밀번호를 메일로 전송하였습니다.', nil)
        return
      else
        return_data('error', '처리 과정에서 문제가 발생했습니다. 다시 시도해주세요.', nil)
        return
      end
    end

    return_data('error', '해당되는 유저가 없습니다.', nil)
  end

=begin
  def require_auth_token
    unless @session.email.end_with? "@snu.ac.kr"
      return_data('error', '서울대학교 학생만 인증하실 수 있습니다.', nil)
    else
      @session.generate_auth_token
      AuthMailer.send_auth_token(@session).deliver
      return_data('success', '메일이 전송되었습니다.', nil)
    end
  end
=end
end
