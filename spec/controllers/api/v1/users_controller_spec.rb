require 'spec_helper'
require 'rails_helper'

describe Api::V1::UsersController do

  before(:each) do
    request.headers['Accept'] = "application/mepedia.v1, #{Mime::JSON}"
  end

  describe 'POST #create' do

    context 'the user does not exists' do

      before(:each) do
        @user = {email: 'mail@mepedia.com', password: '12345678', name: 'mail', lastname: 'media' }
        post :create, {user: @user}
      end

      it 'succesfully saves the user' do
        expect(JSON.parse(response.body, symbolize_names: true)[:user]).to eq @user
      end

      it 'http response 202' do
        assert_response :created
      end
    end

    context 'the user already exists' do

      before(:each) do
        @user = FactoryGirl.create :user
        post :create, {user: {email: @user.email, password: @user.password, name: @user.name, lastname: @user.lastname }}
      end

      it 'fails with http code 422' do
        resp = JSON.parse(response.body, symbolize_names: true)
        expected = {reasons: {email: ['has already been taken'] }}
        expect(resp[:errors]).to eq expected
      end
    end

    context 'bad request' do

      before(:each) do
        @user = FactoryGirl.create :user
        post :create, {user: {email: @user.email, password: @user.password, name: @user.name, lastname: @user.lastname }}
      end

      it 'return http code 400' do
        assert_response :unprocessable_entity
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'the user exists' do

      before(:each) do
        request.headers['Authorization'] = "token"
        @user = FactoryGirl.create :user
        delete :destroy, :id => @user.uid
      end

      it 'http response 501' do
        assert_response :not_implemented
      end
    end
  end
end