module DockerRegistry
  module Backends
    class BaseBackend
      @prefix = 'Base'

      class << self
        attr_reader :prefix

        def repository(*args)
          Backends.const_get("#{prefix}Repository").new(*args)
        end

        def repositories
          Backends.const_get("#{prefix}Repository").all
        end

        def image(*args)
          Backends.const_get("#{prefix}Image").new(*args)
        end

        def config
          App.settings.respond_to?(:backends) && App.settings.backends[prefix.downcase] || {}
        end
      end
    end
  end
end
