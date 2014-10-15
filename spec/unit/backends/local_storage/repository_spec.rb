require 'spec_helper'

describe DockerRegistry::Backends::LocalStorageRepository do
  before { DockerRegistry::App.settings.backend = 'local_storage' }

  let(:namespace) { 'test' }
  let(:repository) { 'test' }
  let(:instance) { described_class.new namespace, repository }

  subject { instance }

  it_behaves_like 'repository'

  describe '#path' do
    subject { instance.path }

    it { should be_a String }
    it { should include namespace }
    it { should include repository }
  end

  describe '#metadata_path' do
    subject { instance.metadata_path }

    it { should start_with instance.path }
    it { should end_with 'json' }
  end

  describe '#exist?' do
    before do
      expect(Dir).to receive(:exist?).with(instance.path).once
    end
    subject { instance.exist? }

    it('should use Dir.exist?') { should be_nil }
  end

  describe '#metadata_exist?' do
    before do
      expect(File).to receive(:exist?).with(instance.metadata_path).once
    end
    subject { instance.metadata_exist? }

    it('should use File.exist?') { should be_nil }
  end

  describe '#create' do
    before do
      expect(FileUtils).to receive(:mkdir_p).with(instance.path).once
    end
    subject { instance.create }

    it('should use FileUtils.mkdir_p') { should be_nil }
  end

  describe '#delete!' do
    before do
      expect(FileUtils).to receive(:rm_r).with(instance.path).once
    end
    subject { instance.delete! }

    it('should use FileUtils.rm_r') { should be_nil }
  end

  describe '#load_metadata' do
    before do
      expect(instance).to receive(:metadata_exist?).with(no_args).once { true }
      expect(IO).to receive(:read).with(instance.metadata_path).once { '[]' }
    end
    subject { instance.load_metadata }

    it('should use IO.read') { should eq [] }
  end

  describe '#metadata' do
    subject { instance.metadata }
    context 'calls load_metadata if @metadata is falsy' do
      before do
        expect(instance).to receive(:load_metadata).with(no_args) { [] }
      end
      it('calls load_metadata if @metadata is falsy') { should eq [] }
    end

    context 'returns with @metadata if @metadata is truthy' do
      before { instance.instance_variable_set :@metadata, [] }

      it { should eq [] }
    end
  end

  describe '#metadata=' do
    subject { instance.metadata = [] }

    before do
      expect(instance).to receive(:create).with(no_args)
      expect(IO).to receive(:write).with(instance.metadata_path, '[]').once
    end

    it('writes the metadata to file also') { should eq [] }
  end

  describe '#tag' do
    let(:tag_name) { 'latest' }
    let(:image) { DockerRegistry::Backends::LocalStorageImage.new 'abc' }
    subject { instance.tag tag_name, image }

    it { should be_a DockerRegistry::Backends::LocalStorageTag }
    its(:name) { should eq tag_name }
    its(:image) { should eq image }
  end

  describe '#tags' do
    let(:files) { ['aaa/b'] }

    subject { instance.tags }

    before do
      expect_any_instance_of(DockerRegistry::Backends::LocalStorageTag).to receive(:exist?) { true }
      allow_any_instance_of(DockerRegistry::Backends::LocalStorageTag).to receive(:image) { DockerRegistry::Backends::BaseImage.new 'a' }
      expect(Dir).to receive(:glob).with(kind_of(String)).once { files }
    end

    it('uses Dir.glob') { should be_a Hash }
  end

  describe '::all' do
    before do
      expect(Dir).to receive(:glob).and_return(['storage/repositories/test/scratch'])
    end
    subject { described_class.all }

    it { should be_an Array }
  end
end
