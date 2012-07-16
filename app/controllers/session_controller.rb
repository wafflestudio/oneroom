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
      return_data('error', 'User does not exist.', nil)
    elsif user == User::PASSWORD
      return_data('error', 'Password does not match.', nil)
    else
      session[:user] = user.id
      return_data('success', 'Logged in', user)
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
    return_data('success', 'Loggde out', nil)
  end
end
