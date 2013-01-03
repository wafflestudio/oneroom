#encoding: utf-8
class Admin::EvaluationsController < Admin::ApplicationController
  layout 'admin'

  def index
    @evaluations = Evaluation.all

  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end
 
  def edit
    @evaluation = Evaluation.find(params[:id])
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    if @evaluation.update_attributes(params[:evaluation])
      redirect_to admin_evaluation_path(@evaluation)
    else
      render :edit
    end
  end


  def destroy

    redirect_to admin_evaluations_path
  end
end
