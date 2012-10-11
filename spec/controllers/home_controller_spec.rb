require 'spec_helper'

describe HomeController do
  describe 'GET #index'  do
    it "should assign @users to all users" do
      get :index
      expect(assigns :users).to eql User.all
    end
    it "should return HTTP success" do
      get :index
      expect(response).to be_success
    end
  end
end