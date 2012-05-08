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


end
