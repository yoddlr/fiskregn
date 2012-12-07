require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build :user).to be_valid
  end

  it "is a member of _omni group" do
    new_user = create :user
    expect(new_user.groups).to include(Group.find_by_name('_omni'))
  end
  
  describe 'validations' do
    
    before :all do
      @user = build :user
    end
    
    describe 'Email' do
      it "is required" do
        @user.email = nil
        expect(@user).to_not be_valid
      end
      it "must be unique" do
        previous_user = create :user
        @user.email = previous_user.email
        expect(@user).to_not be_valid
      end
    end
    
    describe 'Password' do
      it "has at least 6 characters" do
        build(:user, password: '123ab').should_not be_valid
      end
    
      it "has at least 1 digit" do
        build(:user, password: 'abcdef%').should_not be_valid
      end
    
      it "has at least 1 letter" do
        build(:user, password: '123456.').should_not be_valid
      end
      it "can contain symbols, letters and numbers" do
        expect(build(:user, password: 'xc#4g%sd', password_confirmation: 'xc#4g%sd')).to be_valid
      end
    end
  end

  describe "Users location" do
    before :each do
      @user = create :user
    end

    it "exists" do
      expect(@user.location).to be_a Location
    end

    it "is owned by user" do
      expect(@user.location.owner).to eq @user
    end

    it "owner has read access" do
      pending "Read and write access for locations not working yet"
    end

    it "owner has write access" do
      pending "Read and write access for locations not working yet"
    end
  end

  describe "current_user" do

    it "returns given user" do
      @user = create :user
      User.stub(:current_user).and_return(@user)
      expect(User.current_user).to eq @user
    end
  end
  
  describe "Readables" do
    before :each do
      @user = create :user
      @content = create :text_content

      # Give @user readaccess to content
      @content.readers << @user
      @content.save
    end

    it "lists accessible content as a readable" do
      expect(@user.readables.include?(@content)).to be_true
    end
  end
end
