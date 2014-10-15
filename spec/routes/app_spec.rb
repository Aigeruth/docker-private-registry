require 'spec_helper'

describe 'GET /swagger' do
  include Rack::Test::Methods

  def app
    DockerRegistry::App
  end

  subject { last_response }

  describe '/' do
    before { get '/' }

    its(:status) { should eq 200 }
  end

  describe '/repositories/:namspace/:name' do
    before { get '/repositories/test/dummy' }

    its(:status) { should eq 200 }
  end

  describe 'GET /swagger' do
    before { get '/swagger' }

    its(:status) { should eq 200 }
  end
end
