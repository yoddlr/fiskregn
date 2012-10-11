require 'spec_helper'

describe UsersController do
  describe "GET #show" do
    before :each do
      @user = create :user
      get :show, id: @user.id
    end
    it "assigns @user to requested user" do
      expect(assigns(:user)).to eql @user
    end
    it "returns HTTP success" do
      expect(response).to be_success
    end
  end
end
