# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :update, :destroy, :edit, :change_status]

  def index
    @histories = History.where('status = ?', params[:status])
    render json: @histories.as_json(include: [:owner, :requester])
  end

  def new
    @history = History.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @history = History.new(histories_params)
    @history.owner = current_person
    @history.project_id = session[:default_project]
    if @history.save
      flash.now[:notice] = t(:success_create)
      flash.keep(:notice)
      redirect_to authenticated_root_url
    else
      flash.now[:error] = @history.errors.full_messages.first
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    render json: @history
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @history.update_attributes(histories_params)
      flash.now[:notice] = t(:success_update)
      flash.keep(:notice)
      redirect_to authenticated_root_url
    else
      flash.now[:error] = @history.errors.full_messages.first
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @history.destroy
    flash.now[:notice] = t(:success_delete)
    flash.keep(:notice)
    redirect_to authenticated_root_url
  end

  def change_status
    @history.send("#{params[:event]}!")
    render json: @history, status: :ok
  rescue StandardError => e
    render json: { errors: e }, status: 500
  end

  private

  def histories_params
    params.require(:history).permit(:name, :requester_id, :status, :description, :started_at, :finished_at, :deadline, :points)
  end

  def set_history
    @history = History.find params[:id]
  end
end
