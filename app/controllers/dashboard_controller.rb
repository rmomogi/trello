class DashboardController < BaseController
	before_action :authenticate_person!

	def index
		@projects = Project.all
		if session[:default_project]
			@default_project = Project.find session[:default_project]
		else
			@default_project = nil
		end

		@histories_pending = History.pending.by_project(session[:default_project])
		@histories_started = History.started
		@histories_delivered = History.delivered
		@histories_done = History.done

	end

	def change_default_project
		session[:default_project] = params[:id]
		redirect_to action: 'index'
	end
end
