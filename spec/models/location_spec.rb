require 'spec_helper'

describe Location do
  it 'has a valid factory' do
    location = build :location
    expect(location).to be_valid
  end
end
