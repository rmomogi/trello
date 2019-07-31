# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do
  let(:owner) { create(:person) }
  let(:requester) { create(:person) }
  let(:project) { create(:project, manager: owner) }

  before do
    login_user
    session[:default_project] = project.id
  end

  describe 'GET #new' do
    it 'return new history' do
      post :new, format: :js
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    let(:history) { build(:history, owner: owner, requester: requester, project: project) }

    it 'way success' do
      post :create, params: generate_params('create'), format: :js
      expect(response).to redirect_to(authenticated_root_url)
    end

    it 'way failed' do
      history.name = nil
      post :create, params: generate_params('create'), format: :js
      expect(flash[:error]).to be_present
    end
  end

  describe 'UPDATE #create' do
    let(:history) { create(:history, owner: owner, requester: requester, project: project) }

    it 'way success' do
      put :update, params: generate_params('update').merge!(id: history.id)
      expect(response).to redirect_to(authenticated_root_url)
    end

    it 'way failed' do
      history.name = nil
      post :update, params: generate_params('update').merge!(id: history.id), format: :js
      expect(flash[:error]).to be_present
    end
  end

  describe 'GET #edit' do
    let(:history) { create(:history, owner: owner, requester: requester, project: project) }

    it 'return status 200' do
      get :edit, params: { id: history.id }, xhr: true
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:history) { create(:history, owner: owner, requester: requester, project: project) }

    it 'way success' do
      get :show, params: { id: history.id }, format: :js
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    let(:history) { create(:history, owner: owner, requester: requester, project: project) }

    it 'way success' do
      delete :destroy, params: { id: history.id }, format: :js
      expect(response).to redirect_to(authenticated_root_url)
    end
  end

  describe 'POST #change_status' do
    let(:history) { create(:history, owner: owner, requester: requester, project: project) }

    it 'when starting' do
      post :change_status, params: { id: history.id, event: 'starting' }, format: :js
      history.reload
      expect(history.started?).to be_truthy
    end

    it 'when delivering' do
      history.status = :started
      history.save
      post :change_status, params: { id: history.id, event: 'delivering' }, format: :js
      history.reload
      expect(history.delivered?).to be_truthy
    end

    it 'when donning' do
      history.status = :delivered
      history.save
      post :change_status, params: { id: history.id, event: 'donning' }, format: :js
      history.reload
      expect(history.done?).to be_truthy
    end

    context 'when failed' do
      it 'send invalid event' do
        post :change_status, params: { id: history.id, event: 'delivering' }, format: :js
        expect(flash[:error]).to be_present
      end
    end
  end

  private

  def generate_params(action)
    { "history" =>
        { "name" => history.name,
          "requester_id" => history.requester_id,
          "status" => history.status,
          "owner_id" => history.owner_id,
          "description" => history.description,
          "started_at" => history.started_at,
          "finished_at" => history.finished_at,
          "deadline" => history.deadline,
          "points" => history.points },
      "controller" => "histories",
      "action" => action.to_s,
      "format" => "json" }
  end
end
