require 'securerandom'

require_relative 'v1/ping'
require_relative 'v1/image'
require_relative 'v1/repository'

module DockerRegistry
  module V1
    class API < ::Grape::API
      api_version = 'v1'
      version api_version, using: :path
      format :json
      default_format :json
      # Grape next release is going to support :binary filter.
      # Related PR: https://github.com/intridea/grape/pull/745
      content_type :binary, 'application/octet-stream'
      formatter :binary, ->(object, _env) { object }

      helpers Backends::Helpers

      mount V1::PingAPI
      mount V1::RepositoryAPI
      mount V1::ImageAPI

      add_swagger_documentation DEFAULT_SWAGGER_OPTIONS.merge(api_version: api_version)
    end
  end
end
