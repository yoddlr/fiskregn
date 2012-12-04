require 'spec_helper'

describe Topic do
  it 'has a valid factory' do
    topic = build :topic
    expect(topic).to be_valid
  end

  it 'can be attached to a location' do
    topic = build :topic
    location = build :location
    location.topics << topic
    location.save

    expect(location).to be_valid
  end

end
