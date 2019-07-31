# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def resource_name
    :person
  end

  def new
    build_resource({})
    respond_with resource
  end

  def create
    resource = Person.new(sign_up_params)
    resource.role = 'User'
    if resource.save
      flash[:notice] = t(:success_create)
      flash.keep(:notice)
      render js: "window.location = '/people/sign_in'"
    else
      flash.now[:error] = resource.errors.full_messages.first
      respond_to do |format|
        format.js
      end
    end
  end

  def sign_up_params
    params.require(:person).permit(:name, :email, :password, :password_confirmation)
  end
end
