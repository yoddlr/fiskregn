require 'spec_helper'

describe ContentsController do

  describe "GET 'new'" do
    
    before :each do
      @user = create :user
    end
    
    it "returns http success" do
      get 'new', user: @user.id
      response.should be_success
    end
    
    it "assigns @content to a new Content object" do
      get 'new', user: @user.id
      expect(assigns(:content)).to be_a_new(Content)
    end
    
    it "assigns current user to @user" do
      get :new, user: @user.id
      expect(assigns(:user)).to eql User.find(@user.id)
    end
    
    it 'renders the new content template' do
      get :new, user: @user.id
      expect(response).to render_template :new
    end
  end
end
