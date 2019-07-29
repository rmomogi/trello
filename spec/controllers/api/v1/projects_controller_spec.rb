require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
	let(:manager) { create(:person) }

  describe 'GET #new' do
    before { post :new, format: :json }
    it 'return status 200' do
      expect(response.status).to eq 200
    end

    it 'return new task' do
      expect(response).to match_response_schema("project", strict: true)
    end
  end

  describe 'POST #create' do
    let(:project) { build(:project, manager: manager) }

    it 'way success' do
      post :create, params: generate_params('create')
      expect(response).to be_successful
    end

    it 'way failed' do
      project.name = nil
      post :create, params: generate_params('create')
      expect(response).not_to be_successful
    end
  end

  describe 'GET #edit' do
    let(:project) { create(:project, manager: manager) }
    before { get :edit, params: { id: project.id }, format: :json }

    it 'return status 200' do
      expect(response).to be_successful
    end

    it 'return project' do
      expect(response).to match_response_schema("project", strict: true)
    end
  end

  describe 'UPDATE #create' do
    let(:project) { create(:project, manager: manager) }

    it 'way success' do
      put :update, params: generate_params('update').merge!(id: project.id)
      expect(response).to be_successful
    end

    it 'way failed' do
      project.name = ''
      put :update, params: generate_params('update').merge!(id: project.id)
      expect(response).not_to be_successful
    end
  end

  describe 'GET #show' do
    let(:project) { create(:project, manager: manager) }

    it 'way success' do
      get :show, params: { id: project.id }, format: :json
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    let(:project) { create(:project, manager: manager) }

    it 'way success' do
      delete :destroy, params: { id: project.id }, format: :json
      expect(response).to be_successful
    end
  end

  private

  def generate_params(action)
    { "project"=>
        { "name"=> project.name,
          "manager_id"=> project.manager_id
        },
        "controller"=>"projects",
        "action"=>"#{action}",
        "format"=> "json" }
  end
end
