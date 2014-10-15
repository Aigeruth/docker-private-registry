require 'spec_helper'

describe DockerRegistry::Backends::BaseImage do
  let(:id) { 'test' }
  let(:instance) { described_class.new id }

  subject { instance }

  its(:id) { should eq id }

  describe '#checksum=(checksum)' do
    let(:error_msg) { 'Invalid checksum!' }
    let(:checksum) { nil }

    subject do
      -> { instance.checksum = checksum }
    end

    context 'checksum = nil' do
      it { should raise_error(RuntimeError, error_msg) }
    end

    context 'checksum = ""' do
      let(:checksum) { '' }

      it { should raise_error(RuntimeError, error_msg) }
    end

    context 'checksum = "sha256:aaaa"' do
      let(:checksum) { 'sha256:aaa' }

      it { should raise_error(RuntimeError, error_msg) }
    end

    context 'checksum = "sha256:" + "a" * 64' do
      let(:checksum) { 'sha256:' + 'a' * 64 }
      subject { instance.checksum = checksum }

      it { should be checksum }
    end
  end

  describe '#metadata=(metadata)' do
    let(:metadata) { nil }

    subject do
      -> { instance.metadata = metadata }
    end

    context 'metadata = nil' do
      it { should raise_error(RuntimeError) }
    end

    context 'metadata = []' do
      let(:metadata) { [] }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = {}' do
      let(:metadata) { {} }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = { "id" => 2 }' do
      let(:metadata) { { 'id' => 2 } }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = { "id" => #id }' do
      let(:metadata) { { 'id' => id } }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = { "id" => #id, "container_config" => "" }' do
      let(:metadata) { { 'id' => id, 'container_config' => '' } }

      subject { instance.metadata = metadata }

      it { should be metadata }
    end
  end
end
