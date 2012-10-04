require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build :user).to be_valid
  end
  
  describe 'validations' do
    
    before :all do
      @user = build :user
    end
    
    it "requires an email" do
      @user.email = nil
      expect(@user).to_not be_valid
    end
    
    describe 'a valid password' do
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
end