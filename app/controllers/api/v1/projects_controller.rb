class Api::V1::ProjectsController < ApplicationController
	before_action :set_project, only: [:show, :update, :destroy, :edit]

  def new
    @project = Project.new
    respond_to do |format|
      format.json { render :json => @project }
    end
  end

  def create
    @project = Project.new(project_params)
    if @project.valid?
      render json: @project, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: 500
    end
  end

  def edit
    render json: @project
  end

  def show
    render json: @project
  end

  def update
    if @project.update_attributes(project_params)
      render json: @task, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: 500
    end
  end

  def destroy
    @project.destroy
    render json: {}, status: :ok
  end

  private

  def project_params
    params.require(:project).permit(:name, :manager_id)
  end

  def set_project
    @project = Project.find params[:id]
  end
end
