Rails.application.routes.draw do

	resources :tasks
	resources :histories
	resources :projects
	post 'histories/change_status', to: 'histories#change_status'
	post 'dashboard/change_default_project', to: 'dashboard#change_default_project'

	devise_for :people, controllers: { registrations: 'registrations' }

	devise_scope :person do
	  authenticated :person do
	    root 'dashboard#index', as: :authenticated_root
	  end

	  unauthenticated do
	    root 'devise/sessions#new', as: :unauthenticated_root
	  end
	end
end
