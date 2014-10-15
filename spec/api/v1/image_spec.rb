require 'spec_helper'

describe DockerRegistry::V1::ImageAPI do
  include Rack::Test::Methods

  def app
    DockerRegistry::V1::API
  end

  def repository_does_not_exist
    allow_any_instance_of(DockerRegistry::Backends::Dummy::Repository).to receive(:exist?).and_return(false)
  end

  subject { last_response }

  describe 'images' do
    describe 'GET /v1/images/abcdef/json' do
      before { get '/v1/images/abcdef/json' }

      its(:status) { should eq 200 }
      its(:body) { should have_json_path 'id' }
      its(:body) { should have_json_path 'container_config' }
    end

    describe 'PUT /v1/images/abcdef/json' do
      let(:body) do
        { 'api.request.body' => { 'id' => 'abcdef', 'container_config' => {} } }
      end

      before { put '/v1/images/abcdef/json', {}, body }

      its(:status) { should eq 200 }
      its(:body) { should be_json_eql 'true' }
    end

    describe 'HEAD /v1/images/abcdef/layer' do
      before { head '/v1/images/abcdef/layer' }

      its(:status) { should eq 200 }
      its(['content-length']) { should_not be_empty }
    end

    describe 'GET /v1/images/abcdef/layer' do
      before { get '/v1/images/abcdef/layer' }

      its(:status) { should eq 200 }
    end

    describe 'PUT /v1/images/abcdef/layer' do
      before { put '/v1/images/abcdef/layer' }

      its(:status) { should eq 200 }
    end

    describe 'PUT /v1/images/abcdef/checksum' do
      before do
        header 'X-Docker-Checksum-Payload', 'sha256:' + 'a' * 64
        put '/v1/images/abcdef/checksum'
      end

      its(:status) { should eq 200 }
      its(:body) { should eq 'null' }
    end

    describe 'GET /v1/images/abcdef/ancestry' do
      before { get '/v1/images/abcdef/ancestry' }

      its(:status) { should eq 200 }
      its(:body) { should have_json_size 1 }
      its(:body) { should be_json_eql '["dummy_id"]' }
    end
  end
end
