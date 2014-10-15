require 'spec_helper'

describe DockerRegistry::V1::RepositoryAPI do
  include Rack::Test::Methods

  def app
    DockerRegistry::V1::API
  end

  def repository_does_not_exist
    allow_any_instance_of(DockerRegistry::Backends::DummyRepository).to receive(:exist?).and_return(false)
  end

  subject { last_response }

  describe 'repositories' do
    describe 'GET /v1/repositories/library/dummy' do
      before { get '/v1/repositories/library/dummy' }

      its(:status) { should eq 200 }
      its(:body) { should have_json_size 1 }
      its(:body) { should have_json_path '0/id' }
      its(:body) { should_not have_json_path '1/id' }

      context 'if repository does not exists' do
        before do
          repository_does_not_exist
          get '/v1/repositories/library/dummy'
        end

        its(:status) { should eq 404 }
      end
    end

    describe 'PUT /v1/repositories/library/dummy' do
      let(:host) { 'registry.example.org' }
      let(:body) do
        {
          'api.request.body' => [{ 'id' => 'abcdef' }],
          'SERVER_NAME' => host
        }
      end

      before { put '/v1/repositories/library/dummy', {}, body }

      its(:status) { should eq(200) }
      its(:body) { should have_json_size 1 }
      its(['x-docker-endpoints']) { should_not be_empty }
      its(['x-docker-endpoints']) { should include host }
      its(['www-authenticate']) { should include 'library' }
      its(['www-authenticate']) { should include 'dummy' }
      its(['x-docker-token']) { should include 'library' }
      its(['x-docker-token']) { should include 'dummy' }

      context 'invalid metadata' do
        let(:body) do
          { 'api.request.body' => [{}] }
        end

        its(:status) { should eq 400 }
      end

      context 'if repository does not exists' do
        let(:body) do
          { 'api.request.body' => [{ 'id' => 'abcdef' }] }
        end
        before do
          allow_any_instance_of(DockerRegistry::Backends::DummyRepository).to receive(:exist?).and_return(false)
          put '/v1/repositories/library/dummy', {}, body
        end

        its(:status) { should eq 200 }
      end
    end

    describe 'DELETE /v1/repositories/library/dummy' do
      before { delete '/v1/repositories/library/dummy' }

      its(:status) { should eq 200 }

      context 'if repository does not exists' do
        before do
          allow_any_instance_of(DockerRegistry::Backends::DummyRepository).to receive(:exist?).and_return(false)
          delete '/v1/repositories/library/dummy'
        end

        its(:status) { should eq 404 }
      end
    end

    describe 'GET /v1/repositories/library/dummy/images' do
      before { get '/v1/repositories/library/dummy/images' }

      its(:status) { should eq(200) }
      its(:body) { should have_json_path '0/id' }
      its(:body) { should_not have_json_path '1/id' }
      context 'if repository does not exists' do
        before do
          allow_any_instance_of(DockerRegistry::Backends::DummyRepository).to receive(:exist?).and_return(false)
          get '/v1/repositories/library/dummy/images'
        end

        its(:status) { should eq 404 }
      end
    end

    describe 'PUT /v1/repositories/library/dummy/images' do
      before { put '/v1/repositories/library/dummy/images', {}, body }

      context 'with invalid metadata' do
        let(:body) do
          { 'api.request.body' => '{}' }
        end

        its(:status) { should eq(400) }
      end

      context 'with valid metadata' do
        let(:body) do
          { 'api.request.body' => [{ 'id' => 'abcdef' }] }
        end

        its(:status) { should eq(204) }
      end
    end

    describe 'GET /v1/repositories/library/dummy/tags' do
      before { get '/v1/repositories/library/dummy/tags' }

      its(:status) { should eq(200) }
    end

    describe 'PUT /v1/repositories/library/dummy/tags/latest' do
      let(:body) do
        { 'api.request.body' => 'latest_id' }
      end

      before { put '/v1/repositories/library/dummy/tags/latest', {}, body }

      its(:status) { should eq(200) }
    end

  end
end
