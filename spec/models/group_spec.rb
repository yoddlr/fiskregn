require 'spec_helper'

describe Group do
  before :each do
    @group = create :group
  end
  it "has a valid factory" do
    expect(build :group).to be_valid
  end
  
  it "has a location" do
    expect(@group.location).to be_a Location
  end

  describe "Member management" do
    it "can add a member" do
      new_member = create :user
      @group.members << new_member
      expect(@group.members.exists?(new_member)).to be_true
    end
  end
end
