require 'rails_helper'

RSpec.describe Api::V1::HistoriesController, type: :controller do
	let(:owner) { create(:person) }
	let(:requester) { create(:person) }

  describe 'GET #new' do
    it 'return new history' do
      post :new, format: :json
      expect(response.status).to eq 200
      expect(response).to match_response_schema("history", strict: true)
    end
  end

  describe 'POST #create' do
    let(:history) { build(:history, owner: owner, requester: requester) }

    it 'way success' do
      post :create, params: generate_params('create')
      expect(response).to be_successful
    end

    it 'way failed' do
      history.name = nil
      post :create, params: generate_params('create')
      expect(response).not_to be_successful
    end
  end

  describe 'UPDATE #create' do
    let(:history) { create(:history, owner: owner, requester: requester) }

    it 'way success' do
      put :update, params: generate_params('update').merge!(id: history.id)
      expect(response).to be_successful
    end

    it 'way failed' do
      history.name = nil
      post :update, params: generate_params('update').merge!(id: history.id)
      expect(response).not_to be_successful
    end
  end

  describe 'GET #edit' do
    let(:history) { create(:history) }
    before { get :edit, params: { id: history.id }, format: :json }

    it 'return status 200' do
      expect(response).to be_successful
    end

    it 'return task' do
      expect(response).to match_response_schema("history", strict: true)
    end
  end

  describe 'GET #show' do
    let(:history) { create(:history, owner: owner, requester: requester) }

    it 'way success' do
      get :show, params: { id: history.id }, format: :json
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    let(:history) { create(:history, owner: owner, requester: requester) }

    it 'way success' do
      delete :destroy, params: { id: history.id }, format: :json
      expect(response).to be_successful
    end
  end

  describe 'POST #change_status' do
    let(:history) { create(:history, owner: owner, requester: requester) }

    it 'when starting' do
      post :change_status, params: { id: history.id, event: 'starting' }, format: :json
      history.reload
      expect(history.started?).to be_truthy
    end

    it 'when delivering' do
      history.status = :started
      history.save
      post :change_status, params: { id: history.id, event: 'delivering' }, format: :json
      history.reload
      expect(history.delivered?).to be_truthy
    end

    it 'when donning' do
      history.status = :delivered
      history.save
      post :change_status, params: { id: history.id, event: 'donning' }, format: :json
      history.reload
      expect(history.done?).to be_truthy
    end
  end

  private

  def generate_params(action)
    { "history"=>
        { "name"=> history.name,
          "requester_id"=> history.requester_id,
          "status"=> history.status,
          "owner_id"=> history.owner_id,
          "description"=> history.description,
          "started_at"=> history.started_at,
          "finished_at"=> history.finished_at,
          "deadline"=> history.deadline,
          "points"=> history.points
        },
        "controller"=>"histories",
        "action"=>"#{action}",
        "format"=> "json" }
  end
end
