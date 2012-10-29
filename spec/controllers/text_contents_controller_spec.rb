require 'spec_helper'

describe TextContentsController do

    context 'as signed in user' do
      before :each do
        # Thanx - https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      describe "GET #new" do    
        it "returns http success" do
          # Since signed in, it shall be possible to create new content
          get 'new', user: @user.id, location: @user.location
          response.should be_success
        end
    
        it "assigns @content to a new TextContent object" do
          get 'new', user: @user.id, location: @user.location
          expect(assigns(:content)).to be_a_new(TextContent)
        end
    
        it 'renders the new content template' do
          get :new, user: @user.id, location: @user.location
          expect(response).to render_template :new
        end
      end
      
      describe "POST #create" do        
        context "stand alone content" do
          before :each do
            @stand_alone = attributes_for :text_content
          end
          
          it "saves the new text content" do
            expect{
              post :create, text_content: @stand_alone
            }.to change{ Content.all.count}.by(1)
          end
          
          it "redirects to signed in users location" do
            post :create, text_content: @stand_alone
            expect(response).to redirect_to user_path(@user)
          end
        end
        
        context "reply" do
          
          
          
          before :each do
            # FactoryGirl.attributes_for(:text_reply) can't seem to return proper parent to controller
            @parent = create :text_content, user: @user
            @reply = attributes_for( :text_reply, parent_id: @parent.id)
          end
          
          it "saves the new text content" do
            expect{
              post :create, text_content: @reply
            }.to change{ Content.all.count}.by(1)
          end
          
          it "has one parent" do
              post :create, text_content: @reply
            expect(@user.contents.last.parent).to eq @parent
          end
          
          it "redirects to the parent content" do
              post :create, text_content: @reply
            expect(response).to redirect_to content_path(@parent)
          end
        end
      end
  
      describe "GET #edit" do
        before :each do
            @content = create :text_content, user: @user
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
            @content = create :text_content, user: @user
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

      describe "DELETE #destroy with children" do
        before :each do
          @content = create :text_content, user: @user

          @child = create :text_content, user: @user
          @content.children << @child
        end

        it "@content should have child @child" do
          expect(@content.children).to include(@child)
        end

        it "fails to delete content with children" do
          delete :destroy, id:@content.id
          # Reverting to root type => content exists but no longer the same
          expect(Content.find(@content.id)).to_not be nil
        end

      end
    end
  
    context 'as guest user' do
      after :each do
        # expect(response).to redirect_to root_url
        expect(response).to raise_error
      end
      
      describe 'GET #edit' do
        it "should redirect away from edit content form" do
          @content = create :text_content
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
          @content = create :text_content
          delete :destroy, id: @content.id
        end
      end
    end
end
