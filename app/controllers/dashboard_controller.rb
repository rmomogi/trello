# frozen_string_literal: true

class DashboardController < BaseController
  before_action :authenticate_person!

  def index
    @projects = Project.all
    @default_project = if session[:default_project]
                         Project.find session[:default_project]
                       end

    @histories_pending = History.pending.by_project(session[:default_project])
    @histories_started = History.started.by_project(session[:default_project])
    @histories_delivered = History.delivered.by_project(session[:default_project])
    @histories_done = History.done.by_project(session[:default_project])
  end

  def change_default_project
    session[:default_project] = params[:id]
    redirect_to action: 'index'
  end
end
