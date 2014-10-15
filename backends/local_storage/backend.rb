module DockerRegistry
  module Backends
    class LocalStorageBackend < BaseBackend
      @prefix = 'LocalStorage'

      class << self
        def storage_path
          config['storage_path'] || 'storage'
        end
      end
    end
  end
end
