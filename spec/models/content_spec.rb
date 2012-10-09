require 'spec_helper'

describe Content do
  it 'has a valid factory' do
    content = build :content
    expect(content).to be_valid
  end
    
end
