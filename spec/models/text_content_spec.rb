require 'spec_helper'

describe TextContent do
  it 'has a valid factory' do
    content = build :text_content
    expect(content).to be_valid
  end

  describe "Location" do
    pending
  end
end