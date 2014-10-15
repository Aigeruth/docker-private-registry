require 'active_support/core_ext/string'

require_relative 'dummy'
require_relative 'local_storage'

module DockerRegistry
  module Backends
    module Helpers
      def selected_backend
        App.settings.respond_to?(:backend) && App.settings.backend || 'dummy'
      end

      def backend
        Backends.const_get "#{selected_backend.camelize}Backend"
      end

      def repository
        backend.repository params[:namespace], params[:repository]
      end

      def repositories
        backend.repositories
      end

      def image(image_id = nil)
        backend.image(image_id || params[:image_id])
      end
    end
  end
end
