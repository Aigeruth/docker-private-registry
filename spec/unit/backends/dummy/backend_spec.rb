require 'spec_helper'

describe DockerRegistry::Backends::DummyBackend do
  subject { described_class }

  it_behaves_like 'backend'
end
