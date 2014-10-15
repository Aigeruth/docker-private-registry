require 'grape'

require_relative 'backends/base'
require_relative 'backends/helpers'
require_relative 'api/doc'
require_relative 'api/v1'

module DockerRegistry
  class API < ::Grape::API
    mount V1::API
  end
end
