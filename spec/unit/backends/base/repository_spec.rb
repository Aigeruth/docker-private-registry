require 'spec_helper'

describe DockerRegistry::Backends::BaseRepository do
  let(:namespace) { 'test' }
  let(:repository) { 'test' }
  let(:instance) { described_class.new namespace, repository }

  subject { instance }

  its(:namespace) { should eq namespace }
  its(:name) { should eq repository }
  its(:metadata) { should eq [] }

  describe '#metadata=(metadata)' do
    subject do
      -> { instance.metadata = metadata }
    end

    context 'metadata = nil' do
      let(:metadata) { nil }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = [{}]' do
      let(:metadata) { [{}] }

      it { should raise_error(RuntimeError) }
    end

    context 'metadata = [{ "tag": "latest" }]' do
      let(:metadata) { [{ 'tag' => 'latest' }] }

      it { should raise_error(RuntimeError) }
    end

    describe 'if metadata is valid' do
      subject { instance.metadata = metadata }

      context 'metadata = []' do
        let(:metadata) { [] }

        it { should eq metadata }
      end

      context 'metadata = [{ "id" => 1 }]' do
        let(:metadata) { [{ 'id' => true }] }

        it { should eq metadata }
      end
    end
  end

  describe '#images' do
    subject { instance.images }
    before { allow(instance).to receive(:metadata).and_return(metadata) }
    after { subject }

    context 'default value' do
      let(:metadata) { [] }

      it { should eq [] }
      it { expect(instance).to receive(:metadata).with(no_args) }
    end

    context '@metadta = [{ "id" => 1 }]' do
      let(:metadata) { [{ 'id' => 1 }] }

      it { should eq [{ id: 1 }] }
      it { expect(instance).to receive(:metadata).with(no_args) }
    end

    context '@metadta = [{ "id" => 1, "Tag" => "latest" }]' do
      let(:metadata) { [{ 'id' => 1, 'Tag' => 'latest' }] }

      it { should eq [{ id: 1 }] }
      it { expect(instance).to receive(:metadata).with(no_args) }
    end
  end
end
