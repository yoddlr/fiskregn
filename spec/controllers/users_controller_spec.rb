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
  
  describe "Get #home" do
    before :each do
      # Thanx - https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
      user_content = create :content, user: @user, data: 'Gurksalladdin'
    end
    
    it "assign @contents to current users contents" do
      get :home
      expect(assigns :contents).to eq @user.contents
    end
  end
end
