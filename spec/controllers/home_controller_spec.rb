require 'spec_helper'

describe HomeController do
  describe 'GET #index'  do
    it "should assign @locations to all locations" do
      get :index
      expect(assigns :locations).to eql Location.all
    end
    it "should return HTTP success" do
      get :index
      expect(response).to be_success
    end
  end
end
