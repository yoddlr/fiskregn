require 'spec_helper'

describe Group do

  before :each do
    @group = create :group
  end

  it "has a valid factory" do
    expect(build :group).to be_valid
  end
  
  describe "Groups location" do
    before :each do
      @group = create :group
    end

    it "exists" do
      expect(@group.location).to be_a Location
    end

    it "is owned by group" do
      expect(@group.location.owner).to eq @group
    end
  end

  #describe "Group Admin" do
    #it "has a group admin" do
      #expect(@group.admins.first).to be_a User
    #end

    #it "has read access to groups location" do
      #pending "Fix read and write access to locations first"
    #end

    #it "Can publish to groups location" do
      #pending "Fix read and write access to locations first"
    #end

    #it "Can approve memberships" do
      #pending "Make mehods for applying for membership forst"
    #end

    #it "Can reject memberships" do
      #pending "Make mehods for applying for membership forst"
    #end

    #it "Can suspend members from group" do
      #pending "No suspended membership status yet"
    #end

    #it "Can revoke user's membership" do
      #pending
    #end
  #end

  describe "Members" do
    it "Group can have a member" do
      new_member = create :user
      @group.members << new_member
      expect(@group.members.exists?(new_member)).to be_true
    end
  end

  describe "Admins" do
    it "Group can have an admin" do
      new_admin = create :user
      @group.admins << new_admin
      expect(@group.admins.exists?(new_admin)).to be_true
    end
  end

  describe "Topics" do

    before :each do
      @topic = create :topic
      @group = create :group
    end
    it "Can haz topics" do
      @group.add_topic @topic

      expect(@group.topics.include?(@topic)).to be_true
    end
    it "Finds group by topic name" do
      @group.add_topic @topic

      result = Group.find_by_topic_name @topic.name

      expect(result.include?(@group)).to be_true
    end
  end

  describe "Readables" do
    before :each do
      @group = create :group
      @content = create :text_content

      # Give @group readaccess to content
      @content.reader_groups << @group
      @content.save
    end

    it "lists accessible content as a readable" do
      expect(@group.readables.include?(@content)).to be_true
    end
  end

  describe "Publishable Locations" do
    before :each do
      @user = create :user
      @location = @user.location
      @group = create :group

      @location.publish_groups << @group
      @location.save
    end

    it "lists the locations the groups members can publish to" do
      expect(@group.publishable_locations.include?(@location)).to be_true
    end
  end
end
