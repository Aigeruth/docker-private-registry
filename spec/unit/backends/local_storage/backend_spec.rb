require 'spec_helper'

describe DockerRegistry::Backends::LocalStorageBackend do
  subject { described_class }

  it_behaves_like 'backend'

  context '#storage_path' do
    subject { described_class.storage_path }

    it { should eq 'storage' }
  end
end
