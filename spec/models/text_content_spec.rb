require 'spec_helper'

describe TextContent do
  it 'has a valid factory' do
    content = build :text_content
    expect(content).to be_valid
  end

  describe "Location" do
  end

  describe 'Topics' do
    before :each do
      @content = create :text_content
      @topic = create :topic
    end

    it "Can haz topics" do
      @content.add_topic(@topic)
      expect(@content.topics.include?(@topic)).to be_true
    end

    it "Find content by topic name" do
      @content.add_topic @topic

      result = Content.find_by_topic_name @topic.name
      ALog.debug result

      expect(result.include?(@content)).to be_true
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

      it "can find all owned content" do
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
