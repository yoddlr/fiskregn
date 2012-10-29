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
      @tagged = create :text_content
      @tag = 'Taggety-tag'
      @tagged.tag_list << @tag
      expect(@tagged.tag_list.include?(@tag)).to be true
    end
  end
end