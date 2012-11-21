require 'spec_helper'

describe TextContent do
  it 'has a valid factory' do
    content = build :text_content
    expect(content).to be_valid
  end

  describe "Location" do
  end

  describe 'Tag list' do
    it "has a tag list" do
      @untagged = create :text_content
      expect(@untagged.tag_list.empty?).to be true
    end
    it "it accepts tags" do
      @tagger = build(:user, password: 'taggaDAG11', password_confirmation: 'taggaDAG11')
      @tagged = create :text_content
      @tag = 'Taggety-tag'
      @tagger.tag(@tagged, :with => @tag, :on => 'interest')
      expect(@tagged.tag_list.include?(@tag)).to be true
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
          expect(Content.find(@content.id).description).to eql @content.description
        end
      end
    end
  end
end
