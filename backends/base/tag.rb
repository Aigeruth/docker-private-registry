module DockerRegistry
  module Backends
    class BaseTag
      attr_accessor :image, :name, :repository

      def initialize(name, repository, image = nil)
        self.name = name
        self.repository = repository
        self.image = image || exist? && self.image
      end

      def exist?
        false
      end

      def name=(name)
        fail 'Invalid tag name!' unless name.is_a?(String) && name.length > 0
        @name = name
      end

      def repository=(repository)
        fail 'Has to be an Repository instance!' unless repository.is_a? BaseRepository
        @repository = repository
      end

      def image=(image)
        fail 'Has to be an Image instance!' unless image.is_a? BaseImage
        @image = image
      end
    end
  end
end
