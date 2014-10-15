shared_examples 'repository' do
  it { should respond_to(:namespace).with(0).arguments }
  it { should respond_to(:namespace=).with(1).arguments }

  it { should respond_to(:name).with(0).arguments }
  it { should respond_to(:name=).with(1).arguments }

  it { should respond_to(:metadata).with(0).arguments }
  it { should respond_to(:metadata=).with(1).arguments }

  it { should respond_to(:exist?).with(0).arguments }

  it { should respond_to(:images).with(0).arguments }
  it { should respond_to(:tag).with(2).arguments }
  it { should respond_to(:tags).with(0).arguments }

  it { should respond_to(:delete!).with(0).arguments }

  it { expect(described_class).to respond_to(:all).with(0).arguments }
end
