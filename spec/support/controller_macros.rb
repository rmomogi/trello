# frozen_string_literal: true

module ControllerMacros
  def login_user
    person = create(:person)
    allow_any_instance_of(ApplicationController).to receive(:current_person).and_return(person)
  end
end

RSpec.configure do |config|
  config.include ControllerMacros, type: :controller
  config.include ControllerMacros, type: :helper
end
