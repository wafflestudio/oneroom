class ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    @image = Image.new(:image => params[:Filedata])

    if @image.save
      respond_to do |format|
        format.json {render :layout => false, :json => {:result => 'success', :data => @image}.to_json }
      end
    else
      respond_to do |format|
        format.json {render :layout => false, :json => {:result => 'error', :data => @image}.to_json }
      end
    end
  end

  def destroy

  end
end
