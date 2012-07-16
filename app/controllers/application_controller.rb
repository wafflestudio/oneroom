class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :init_session

  def init_session
  	@session = nil
  	if session[:user]
  		@session = User.find(session[:user])
  	end
  end

  def require_session
    #TODO
  end

  def return_data status, msg, data
    render :json => {'status' => status, 'msg' => msg, 'data' => data}
  end

  def return_html html
    render :json => {'html' => render_to_string(html)}
  end

  def return_data_and_html status, msg, data, html
     render :json => {'status' => status, 'msg' => msg, 'data' => data, 'html' => html}
  end
end
