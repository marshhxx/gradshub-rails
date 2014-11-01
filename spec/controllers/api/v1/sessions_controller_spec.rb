require 'spec_helper'
require 'rails_helper'

describe Api::V1::SessionsController do

  before(:each) do
    request.headers['Accept'] = "application/mepedia.v1, #{Mime::JSON}"
  end

  describe 'POST #create' do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do

      before(:each) do
        credentials = {email: @user.email, password: '12345678' }
        post :create, {session: credentials}
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        expect(JSON.parse(response.body, symbolize_names: true)[:user][:auth_token]).to eql @user.auth_token
      end

      it { assert_response 200 }
    end

    context 'when the password is incorrect' do

      before(:each) do
        credentials = {email: @user.email, password: 'invalidpassword'}
        post :create, {session: credentials}
      end

      it 'returns a json with an error' do
        expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to eql :reasons => ['Invalid email or password']
      end

      it { assert_response 422 }
    end

    context 'when the email is incorrect' do

      before(:each) do
        credentials = {email: 'user', password: '12345678'}
        post :create, {session: credentials}
      end

      it 'returns a json with an error' do
        expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to eql :reasons => ['Invalid email or password']
      end

      it { assert_response 422 }

    end

  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
    end

    context 'when user logged in' do

      before(:each) do
        delete :destroy, {:id => @user.auth_token}
      end

      it 'succesfully logged out' do
        expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eql 'Successfully logged out'
      end

      it 'returns http code 202' do
        assert_response :accepted
      end
    end

    context 'when user is not logged in' do

      before(:each) do
        delete :destroy, {:id => 'invalid_token'}
      end

      it 'responds with error message' do
        delete :destroy, {:id => 'invalid_token'}
        expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to eql :reasons => ['Invalid authentication token. User might not be logged in.']
      end

      it 'returns http code 422' do
        assert_response :unprocessable_entity
      end
    end
  end
end