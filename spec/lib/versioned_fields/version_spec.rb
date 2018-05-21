# frozen_string_literal: true

RSpec.describe VersionedFields do
  it 'has a version' do
    expect(VersionedFields::VERSION).to be_a(String)
  end

  it 'has major, minor, and patch parts separated by dot' do
    expect(VersionedFields::VERSION.split('.').count).to eq(3)
  end
end
