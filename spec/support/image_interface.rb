shared_examples 'image' do
  it { should respond_to(:id).with(0).arguments }
  it { should respond_to(:id=).with(1).arguments }

  it { should respond_to(:metadata).with(0).arguments }
  it { should respond_to(:metadata=).with(1).arguments }

  it { should respond_to(:checksum).with(0).arguments }

  it { should respond_to(:layer).with(0).arguments }
  it { should respond_to(:layer=).with(1).arguments }

  it { should respond_to(:size).with(0).arguments }

  it { should respond_to(:ancestry).with(0).arguments }

  it { should respond_to(:delete!).with(0).arguments }

  it { should respond_to(:exist?).with(0).arguments }
end
