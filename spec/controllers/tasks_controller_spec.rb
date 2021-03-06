# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:person) { create(:person) }
  let(:project) { create(:project, manager: person) }
  let(:history) { create(:history, owner: person, requester: person, project: project) }

  before do
    login_user
  end

  describe 'GET #new' do
    before { post :new, format: :json }

    it 'return status 200' do
      expect(response.status).to eq 200
    end

    it 'return new task' do
      expect(response).to match_response_schema("task", strict: true)
    end
  end

  describe 'POST #create' do
    let(:task) { build(:task, history: history) }

    it 'way success' do
      post :create, params: generate_params('create'), format: :js
      expect(response).to be_successful
    end

    it 'way failed' do
      task.description = nil
      post :create, params: generate_params('create')
      expect(response).not_to be_successful
    end
  end

  describe 'GET #edit' do
    let(:task) { create(:task, history: history) }
    before { get :edit, params: { id: task.id }, format: :json }

    it 'return status 200' do
      expect(response).to be_successful
    end

    it 'return task' do
      expect(response).to match_response_schema("task", strict: true)
    end
  end

  describe 'UPDATE #create' do
    let(:task) { create(:task, history: history) }

    it 'way success' do
      put :update, params: generate_params('update').merge!(id: task.id)
      expect(response).to be_successful
    end

    it 'way failed' do
      task.description = ''
      put :update, params: generate_params('update').merge!(id: task.id)
      expect(response).not_to be_successful
    end
  end

  describe 'GET #show' do
    let(:task) { create(:task, history: history) }

    it 'way success' do
      get :show, params: { id: task.id }, format: :json
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    let(:task) { create(:task, history: history) }

    it 'way success' do
      delete :destroy, params: { id: task.id }, format: :json
      expect(response).to be_successful
    end
  end

  private

  def generate_params(action)
    { "task" =>
        { "description" => task.description,
          "done" => task.done,
          "history_id" => task.history_id },
      "controller" => "tasks",
      "action" => action.to_s,
      "format" => "json" }
  end
end
