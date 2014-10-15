require 'spec_helper'

describe DockerRegistry::Backends::Helpers do
  let(:helper) { Class.new.extend(described_class) }
  subject { helper }

  context '#get_repository' do
    before do
      expect(helper).to receive(:params).twice.and_return(namespace: 'test', repository: 'repository')
    end
    subject { helper.repository }

    its(:namespace) { should eq 'test' }
    its(:name) { should eq 'repository' }
  end

  context '#image' do
    before do
      expect(helper).to receive(:params).once.and_return(image_id: 'image_id')
    end
    subject { helper.image }

    its(:id) { should eq 'image_id' }
  end
end
