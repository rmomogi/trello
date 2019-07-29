Rails.application.routes.draw do

	namespace :api, :defaults => {:format => :json} do
		namespace :v1 do
			resource :tasks
			resource :histories
			resource :projects

			post 'histories/change_status', to: 'histories#change_status'
		end
	end
end
