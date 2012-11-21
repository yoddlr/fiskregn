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
            @reply = attributes_for( :text_content, parent_id: @parent.id)
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

      describe "PUT #update" do
        
        before :each do
          @content = create :text_content, user: @user
        end
        
        it "assigns @content as current content" do
          put :update,id:@content, content: @content
          expect(assigns :content).to eq @content
        end
        
        it "updates the content" do
          new_text = 'new text string'
          put :update,id:@content, text_content: { text: new_text }
          @content.reload
          expect(@content.text).to eq new_text
        end
        
        it "does not update content if owned by other user" do
          other_user = FactoryGirl.create(:user)
          sign_in other_user

          content = create :text_content, user: other_user
          @user.tag(content, :with => ['find','read'], :on => 'access')

          sign_out other_user
          sign_in @user

          new_text = 'new text string'
          put :update, id:content, text_content: { text: new_text }
          content.reload
          expect(content.text).to_not eq new_text
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
        
        it "can only be deleted by owner" do
          other_user = FactoryGirl.create(:user)
          sign_in other_user

          text = 'Text to delete'
          content = create :text_content,  text: text, user: other_user
          @user.tag(content, :with => ['find','read'], :on => 'access')

          sign_out other_user
          sign_in @user

          delete :destroy, id:content.id
          expect(Content.find(content).text).to eq text
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
        
        it "can only be deleted by owner" do
          other_user = FactoryGirl.create(:user)
          sign_in other_user

          text = 'Text to delete'
          content = create :text_content,  text: text, user: other_user
          @user.tag(content, :with => ['find','read'], :on => 'access')

          sign_out other_user
          sign_in @user

          child = create :text_content, parent: content
          delete :destroy, id:content.id
          expect(Content.find(content).text).to eq text
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
          other_user = FactoryGirl.create(:user)
          user = FactoryGirl.create(:user)
          sign_in other_user

          content = create :text_content, user: @user
          user.tag(content, :with => ['read'], :on => 'access')

          sign_out other_user
          sign_in user

          delete :destroy, id: content.id
        end
      end
    end

    describe 'Access' do
      before :each do
        @owner = create :user
        @content = create :text_content, user: @owner, text: 'Dumheter'
      end
      context "owner of content" do
        before :each do
          User.stub(:current_user).and_return(@owner)
        end
        it "has find access" do
          ids = []
          Content.all.each do |content|
            ids << content.id
          end
          expect(ids).to include @content.id
        end
        it "has read access" do
          expect(Content.find(@content.id).description).to eq @content.description
        end
      end

      context "other user than owner of content" do
        before :each do
          @other_user = create :user
          User.stub(:current_user).and_return(@other_user)
        end
        context "without access" do
          it "has no find access" do
            ids = []
            Content.all.each do |content|
              ids << content.id
            end
            expect(ids).to_not include @content.id
          end
          it "has no read access" do
            expect{
              Content.find(@content.id)
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
        context "with only find access" do
          before :each do
            @other_user.tag(@content, with: ['find'], on: 'access')
          end
          it "has find access" do
            pending "Needs working locations"
          end
          it "has no read access" do
            expect{
              Content.find(@content.id)
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
        context "with read access" do
          before :each do
            @other_user.tag(@content, with: ['read'], on: 'access')
          end

          it "has find access" do
            pending 'Neads find method'
          end
          it "has read access" do
            ALog.debug "other user with read access has read access"
            ALog.debug "Contents: #{Content.count}"
            expect(Content.find(@content.id).description).to eql @content.description
          end
        end
      end
    end
end
