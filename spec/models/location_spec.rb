require 'spec_helper'

describe Location do
  it 'has a valid factory' do
    location = build :location
    expect(location).to be_valid
  end

  describe "Publishers" do
    before :each do
      @user = create :user
      group = create :group
      @location = group.location

      @user.publishable_locations << @location
      @user.save
    end

    it "lists users that can publish to this location" do
      expect(@location.publishers.include?(@user)).to be_true
    end
  end

  describe "Publish_groups" do
    before :each do
      @user = create :user
      @group = create :group
      @location = @user.location

      @group.publishable_locations << @location
      @group.save
    end

    it "lists groups that can publish to this location" do
      expect(@location.publish_groups.include?(@group)).to be_true
    end
  end

end
