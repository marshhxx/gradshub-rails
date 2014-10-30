require 'spec_helper'
require 'rails_helper'

describe Api::V1::SessionsController do

  describe "POST #create" do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    before(:each) do
      request.headers['Accept'] = "application/mepedia.v1, #{Mime::JSON}"
    end

    context "when the credentials are correct" do

      before(:each) do
        credentials = {email: @user.email, password: "12345678" }
        post :create, {session: credentials}
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(JSON.parse(response.body, symbolize_names: true)[:auth_token]).to eql @user.auth_token
      end

      it { assert_response 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = {email: @user.email, password: "invalidpassword"}
        post :create, {session: credentials}
      end

      it "returns a json with an error" do
        expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to eql "Invalid email or password"
      end

      it { assert_response 422 }
    end

  end

end