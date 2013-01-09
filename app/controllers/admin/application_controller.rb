#encoding: utf-8
class Admin::ApplicationController < ApplicationController
  before_filter :require_admin
  before_filter :init_title

  def require_admin
    if @session[:admin]
      return
    end

    redirect_to root_path
  end

  def init_title
    @title = controller_name
  end

end
