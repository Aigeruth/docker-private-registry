shared_examples 'backend' do
  it { should respond_to(:config).with(0).arguments }
  context '::config' do
    subject { described_class.config }

    it { should be_a(Hash) }
  end

  it { should respond_to(:repository) }
  it { should respond_to(:repositories).with(0).arguments }
  it { should respond_to(:image) }
end
