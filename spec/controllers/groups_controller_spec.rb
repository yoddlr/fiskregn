require 'spec_helper'

describe GroupsController do

  describe "GET #show" do
    before :each do
      @group = create :group
    end

    it "assigns @group to requested group" do
      get :show, id: @group.id
      expect(assigns :group).to eq @group
    end
  end
end
