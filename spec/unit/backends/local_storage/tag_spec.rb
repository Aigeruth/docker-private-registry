require 'spec_helper'

describe DockerRegistry::Backends::LocalStorageTag do
  let(:name) { 'test' }
  let(:repository) { DockerRegistry::Backends::LocalStorageRepository.new 'a', 'b' }
  let(:image) { DockerRegistry::Backends::LocalStorageImage.new 'test' }
  let(:instance) { described_class.new name, repository, image }

  describe '#path' do
    subject { instance.path }

    it { should be_a String }
    it { should include instance.repository.path }
    it { should end_with "tags/#{name}" }
  end

  describe '#exist?' do
    before do
      expect(File).to receive(:exist?).with(instance.path).once { true }
    end
    subject { instance.exist? }

    it { should be true }
  end

  context '#save' do
    before do
      expect(FileUtils).to receive(:mkdir_p).with(instance.containter_path).once
      expect(File).to receive(:open).with(instance.path, 'w').once
    end
    subject { instance.save }

    it { should be_nil }
  end
end
