require 'spec_helper'

describe Topic do
  it 'has a valid factory' do
    topic = build :topic
    expect(topic).to be_valid
  end
end
