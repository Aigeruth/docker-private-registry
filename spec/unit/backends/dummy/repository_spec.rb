require 'spec_helper'

describe DockerRegistry::Backends::DummyRepository do
  let(:namespace) { 'test' }
  let(:name) { 'dummy' }
  let(:instance) { described_class.new namespace, name }

  subject { instance }

  it_behaves_like 'repository'
end
