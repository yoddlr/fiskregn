require 'spec_helper'

describe ContentsController do

  describe "GET 'new'" do
    
    describe 'as signed in user' do
      before :each do
        # Thanx - https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
    
      it "returns http success" do
        # Since signed in, it shall be possible to create new content
        get 'new', user: @user.id
        response.should be_success
      end
    
      it "assigns @content to a new Content object" do
        get 'new', user: @user.id
        expect(assigns(:content)).to be_a_new(Content)
      end
    
      it 'renders the new content template' do
        get :new, user: @user.id
        expect(response).to render_template :new
      end
    end
    
    describe 'as guest user' do
      it "should redirect away from create content form" do
        get :new
        expect(response).to redirect_to root_url
      end
    end
  end
end
