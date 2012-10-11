require 'spec_helper'

describe ContentsController do

    describe 'as signed in user' do
      before :each do
        # Thanx - https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      describe "GET #new" do    
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
  
      describe "GET #edit" do
        before :each do
            @content = create :content, user: @user
            get :edit, id: @content.id
        end
    
        it "returns the new form" do
          expect(response).to render_template :new
        end
    
        it "assigns @content to chosen content" do
          expect(assigns(:content)).to eql @content
        end
    
        it "returns HTTP success" do
          expect(response).to be_success
        end
      end
      
      describe "DELETE #destroy" do
        before :each do
            @content = create :content, user: @user
        end
        
        it "assigns @content to requested content" do
          delete :destroy, id: @content.id
          expect(assigns :content ).to eql @content
        end
        
        it "deletes the requested content" do
          delete :destroy, id:@content.id
          expect(Content.all).to_not include(@content)
        end
      end
    end
  
    describe 'as guest user' do
      after :each do
        expect(response).to redirect_to root_url
      end
      
      describe 'GET #edit' do
        it "should redirect away from edit content form" do
          @content = create :content
          get :edit, id: @content.id
        end
      end

      describe 'GET #new' do
        it "should redirect away from create content form" do
          get :new
        end
      end

      describe 'DELETE #destroy' do
        it "should redirect away from delete content" do
          @content = create :content
          delete :destroy, id: @content.id
        end
      end
    end
end
