require 'spec_helper'

describe DockerRegistry::V1::PingAPI do
  include Rack::Test::Methods

  def app
    DockerRegistry::V1::API
  end

  subject { last_response }
  before { get '/v1/_ping', {}, 'HTTP_CONTENT_TYPE' => 'application/json' }

  its(:status) { should eq(200) }
  its(:body) { should be_json_eql '{"standalone":true}' }
  its(['x-docker-registry-config']) { should be_empty }
  its(['x-docker-registry-standalone']) { should eq('true') }
  its(['x-docker-registry-version']) { should eq(DockerRegistry::VERSION) }
end
