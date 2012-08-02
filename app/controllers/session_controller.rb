#encoding: utf-8
class SessionController < ApplicationController
  layout :choose_layout

  private
  def choose_layout
    if ['new'].include? action_name
      'tooltip'
    end
  end

  public
  def new
    render :json => {'html' => render_to_string('_new.html.erb')}
  end

  def create
		user = User.login(params[:session][:username], params[:session][:password])

    if user == User::NOTEXIST
      return_data('error', '존재하지 않는 사용자입니다.', nil)
    elsif user == User::PASSWORD
      return_data('error', '비밀번호가 일치하지 않습니다.', nil)
    else
      session[:user] = user.id
      return_data('success', '로그인 성공!', user)
    end
  end

  def show
    if @session
      return_data_and_html('success', nil, @session, render_to_string('_show.html.erb'))
    else
      return_data_and_html('success', nil, nil, render_to_string('_login.html.erb'))
    end
  end

  def destroy
    reset_session
    return_data('success', '로그아웃 되었습니다.', nil)
  end
end
