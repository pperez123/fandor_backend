require 'rails_helper'

RSpec.describe Api::FilmsController, type: :controller do
  before(:each) { request.headers['Accept'] = 'application/json' }

  describe 'GET #show' do
    before(:each) do
      get :show, params: {id: 1}, format: :json
    end

    it 'returns the information about film with id 1' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response).to have_key(:data)
      expect(user_response[:data][:id]).to eql 1
      expect(user_response[:data][:properties][:title]).to eql 'A Wonderful Film'
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      get :index, format: :json
    end

    it 'returns full list of films' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response).to have_key(:data)
      expect(user_response[:data].count).to eql 10
      expect(user_response[:data][9][:properties][:title]).to eql "Perry Hotter: A Lizard's Tale"
    end

    it { should respond_with 200 }
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully saved' do
      before(:each) do
        get :update, params: {id: 1, data: { attributes: {user_id: 1, rating: 3}}}, format: :json
      end

      it 'has created user and film rating records' do
        expect(User.find(1).id).to eql 1
        expect(FilmRating.find(1).rating).to eql 3
      end

      it 'returns "Success" if saved rating' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:data)
        expect(user_response[:data]).to have_key(:status)
        expect(user_response[:data][:status]).to eql 'Success'
      end

      it { should respond_with 200 }
    end

    context 'when is missing user id' do
      before(:each) do
        get :update, params: {id: 1, data: { attributes: {rating: 3}}}, format: :json
      end

      it 'renders errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:data)
        expect(user_response[:data]).to have_key(:error)
        expect(user_response[:data][:error][:description]).to eql 'No user id for rating.'
      end

      it { should respond_with 406 }
    end

  end
end
