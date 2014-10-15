require 'spec_helper'

describe DockerRegistry::Backends::DummyImage do
  let(:id) { 'abcdef' }
  let(:instance) { described_class.new id }
  subject { instance }

  it_behaves_like 'image'
end
