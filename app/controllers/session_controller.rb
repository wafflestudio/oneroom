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
    render :json => {'html' => render_to_string('new.html.erb')}
  end

  def create
		user = User.login(params[:session][:username], params[:session][:password])

    if user == User::NOTEXIST
      render :json => {'status' => 'error', 'msg' => 'User does not exist.'} 
    elsif user == User::PASSWORD
      render :json => {'status' => 'error', 'msg' => 'Password does not match.'}
    else
      session[:user] = user.id
      render :json => {'status' => 'success', 'msg' => 'Logged in', 'data' => user}
    end
  end

  def show
    render :json => {'session' => @session, 'html' => render_to_string('_show.html.erb')}
  end

  def destroy
    reset_session
    render :json => {'msg' => 'Logged out'}
  end
end
