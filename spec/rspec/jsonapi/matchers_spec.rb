require 'spec_helper'

describe Rspec::Jsonapi::Matchers do
  it 'has a version number' do
    expect(Rspec::Jsonapi::Matchers::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
