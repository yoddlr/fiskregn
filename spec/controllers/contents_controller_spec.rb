require 'spec_helper'

describe ContentsController do

  describe "GET 'new'" do
    
    describe 'as signed in user' do
      before :each do
        @user = create :user
        
      end
    
      it "returns http success" do
        user_logged_in?.stub( true)
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
        ALog.debug response
        expect(response).to redirect_to root_url
      end
    end
  end
end
