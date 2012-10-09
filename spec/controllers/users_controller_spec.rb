require 'spec_helper'

describe UsersController do
  
  describe 'GET index' do
    it 'renders the users/index template' do
      get :index
      expect(response).to render_template :index
    end
    it 'assigns all users to @users' do
      user = create :user
      get :index
      expect(assigns(:users)).to eql User.all
    end
  end
end
