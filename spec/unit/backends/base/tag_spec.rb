require 'spec_helper'

describe DockerRegistry::Backends::BaseTag do
  let(:name) { 'test' }
  let(:repository) { DockerRegistry::Backends::BaseRepository.new 'a', 'b' }
  let(:image) { DockerRegistry::Backends::BaseImage.new 'a' }
  let(:image_error_msg) { 'Has to be an Image instance!' }
  let(:instance) { described_class.new name, repository, image }

  subject { instance }

  its(:name) { should eq name }
  its(:repository) { should eq repository }

  describe '#new' do
    subject do
      -> { described_class.new name, repository }
    end

    context 'arguments: name, repository' do
      it { should raise_error RuntimeError, image_error_msg }
    end

    context 'arguments: name, repository, "image"' do
      let(:image) { 'image' }

      it { should raise_error RuntimeError, image_error_msg }
    end

    context 'if image exist' do
      subject { described_class.new name, repository }
      before do
        expect_any_instance_of(described_class).to receive(:exist?) { true }
        allow_any_instance_of(described_class).to receive(:image).with(no_args) { image }
      end

      its(:image) { should eq image }
    end
  end
end
