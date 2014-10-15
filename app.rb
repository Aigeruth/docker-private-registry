require 'sinatra'
require 'sinatra/config_file'
require_relative 'api'
require_relative 'version'

module DockerRegistry
  class App < Sinatra::Base
    include Backends::Helpers
    register Sinatra::ConfigFile

    config_file 'config.yml'

    get '/' do
      haml :index, locals: { repositories: repositories }
    end

    get '/repositories/:namespace/:repository' do
      haml :repository, locals: { repository: repository, url: repository_url(repository) }
    end

    get '/swagger/?:version?' do |version|
      version ||= 'v1'
      haml :swagger, layout: false, locals: { version: version }
    end

    private

    def registry_host
      request.host.dup.tap do |host|
        host << ":#{request.port}" unless [80, 433].include? request.port
      end
    end

    def repository_url(repository)
      "#{registry_host}/#{repository.namespace}/#{repository.name}"
    end
  end
end
