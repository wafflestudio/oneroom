#encoding: utf-8
class Admin::ApplicationController < ApplicationController
  before_filter :require_admin
  before_filter :init_title

  def require_admin

  end

  def init_title
    @title = controller_name
  end

end
