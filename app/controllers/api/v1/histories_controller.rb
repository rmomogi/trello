class Api::V1::HistoriesController < ApplicationController
	before_action :set_history, only: [:show, :update, :destroy, :edit, :change_status]

	def new
		@history = History.new
		respond_to do |format|
      format.json { render :json => @history }
    end
	end

	def create
		@history = History.new(histories_params)
		if @history.valid?
			render json: @history, status: :ok
		else
			render json: { errors: @history.errors.full_messages }, status: 500
		end
	end

	def edit
		render json: @history
	end

	def show
		render json: @history
	end

	def update
		if @history.update_attributes(histories_params)
			render json: @history, status: :ok
		else
			render json: { errors: @history.errors.full_messages }, status: 500
		end
	end

	def destroy
		@history.destroy
    render json: {}, status: :ok
	end

	def change_status
		@history.aasm.fire!(params[:event].to_sym)
	end

	private

	def histories_params
		params.require(:history).permit(:name, :requester_id, :owner_id, :status, :description, :started_at, :finished_at, :deadline, :points)
	end

	def set_history
		@history = History.find params[:id]
	end
end

