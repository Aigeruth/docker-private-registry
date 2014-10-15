module DockerRegistry
  module Backends
    class BaseRepository
      attr_accessor :namespace, :name, :metadata

      def initialize(namespace, name)
        self.namespace = namespace
        self.name = name
      end

      def namespace=(namespace)
        fail 'Invalid repository namespace!' unless !!namespace && namespace.length > 0
        @namespace = namespace
      end

      def name=(name)
        fail 'Invalid repository name!' unless !!name && namespace.length > 0
        @name = name
      end

      def metadata
        @metadata ||= []
      end

      def metadata=(metadata)
        fail 'Has to be an array' if metadata.class != Array
        metadata.each do |image_data|
          fail 'Image data has to contain an ID' unless image_data['id']
        end
        @metadata = metadata
      end

      def images
        metadata.map do |image|
          { id: image['id'] }
        end
      end
    end
  end
end
