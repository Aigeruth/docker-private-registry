require 'spec_helper'

describe DockerRegistry::Backends::LocalStorageImage do
  let(:image_name) { 'test' }
  let(:instance) { described_class.new image_name }
  subject { instance }

  it_behaves_like 'image'

  describe '#path' do
    subject { instance.path }

    it { should be_a String }
    it { should end_with instance.id }
  end

  describe '#metadata_path' do
    subject { instance.metadata_path }

    it { should be_a String }
    it { should start_with instance.path }
    it { should end_with 'json' }
  end

  describe '#layer_path' do
    subject { instance.layer_path }

    it { should be_a String }
    it { should start_with instance.path }
    it { should end_with 'layer' }
  end

  describe '#checksum_path' do
    subject { instance.checksum_path }

    it { should be_a String }
    it { should start_with instance.path }
    it { should end_with 'checksum' }
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
    subject { instance.metadata = { 'id' => instance.id, 'container_config' => {} } }

    before do
      expect(instance).to receive(:create).with(no_args).once
      expect(IO).to receive(:write).with(instance.metadata_path, kind_of(String)).once
    end

    it { should be_a Hash }
  end

  describe '#metadata_exist?' do
    before do
      expect(File).to receive(:exist?).with(instance.metadata_path).once
    end
    subject { instance.metadata_exist? }

    it('should use File.exist?') { should be_nil }
  end

  describe '#layer_exist?' do
    before do
      expect(File).to receive(:exist?).with(instance.layer_path).once
    end
    subject { instance.layer_exist? }

    it('should use File.exist?') { should be_nil }
  end

  describe '#checksum_exist?' do
    before do
      expect(File).to receive(:exist?).with(instance.checksum_path).once
    end
    subject { instance.checksum_exist? }

    it('should use File.exist?') { should be_nil }
  end

  describe '#exist?' do
    before do
      allow(instance).to receive(:metadata_exist?).and_return(true)
      allow(instance).to receive(:layer_exist?).and_return(true)
    end
    subject { instance.exist? }

    it('layer and metadata must exist') { should be true }
  end

  describe '#load_metadata' do
    before do
      expect(instance).to receive(:metadata_exist?).with(no_args).once { true }
      expect(IO).to receive(:read).with(instance.metadata_path).once { '[]' }
    end
    subject { instance.load_metadata }

    it('should use IO.read') { should eq [] }
  end

  describe '#checksum' do
    subject { instance.checksum }
    context 'calls load_checksum if @checksum is falsy' do
      before do
        expect(instance).to receive(:load_checksum).with(no_args) { '' }
      end
      it('calls load_checksum if @checksum is falsy') { should eq '' }
    end

    context 'returns with @checksum if @checksum is truthy' do
      before { instance.instance_variable_set :@checksum, 'aaaa' }

      it { should eq 'aaaa' }
    end
  end

  describe '#load_checksum' do
    before do
      expect(instance).to receive(:checksum_exist?).with(no_args).once { true }
      expect(IO).to receive(:read).with(instance.checksum_path).once { '"sha256:' + 'a' * 64 + '"' }
    end
    subject { instance.load_checksum }

    it('should use IO.read') { should be_a String }
  end

  describe '#layer' do
    before do
      expect(instance).to receive(:layer_exist?).with(no_args).once { true }
      expect(IO).to receive(:binread).with(instance.layer_path).once
    end
    subject { instance.layer }

    it('should use IO.read') { should eq nil }
  end

  describe '#size' do
    before do
      expect(File).to receive(:size?).with(instance.layer_path).once
    end
    subject { instance.size }

    it('should use IO.read') { should eq 0 }
  end

  describe '#layer' do
    let(:data) { '' }
    before do
      expect(instance).to receive(:calculate_checksum).with(no_args).once { 'abc' }
      expect(IO).to receive(:write).with(instance.checksum_path, kind_of(String)).once
      expect(IO).to receive(:binwrite).with(instance.layer_path, data).once
    end
    subject { instance.layer = data }

    it('should use IO.binread') { should eq '' }
  end

  describe '#calculate_checksum' do
    subject { instance.calculate_checksum }
    before do
      expect(IO).to receive(:read).with(instance.metadata_path).once { '' }
      expect(IO).to receive(:binread).with(instance.layer_path).once { '' }
    end

    it { should be_a String }
  end

  describe '#ancestry' do
    subject { instance.ancestry }
    before do
      instance.instance_variable_set :@metadata, 'parent' => 'parent'
      allow(described_class).to receive(:new).with('parent') do
        instance.instance_variable_set :@metadata, 'id' => 'parent'
        instance
      end
      instance.parent
    end
    it { should be_an Array }
  end
end
