# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy, :edit]

  def new
    @task = Task.new
    respond_to do |format|
      format.json { render json: @task }
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: 500
    end
  end

  def edit
    render json: @task
  end

  def show
    render json: @task
  end

  def update
    if @task.update_attributes(task_params)
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: 500
    end
  end

  def destroy
    @task.destroy
    render json: {}, status: :ok
  end

  private

  def task_params
    params.require(:task).permit(:description, :history_id, :done)
  end

  def set_task
    @task = Task.find params[:id]
  end
end
