module DockerRegistry
  module Backends
    class BaseImage
      attr_accessor :id, :metadata, :checksum, :layer

      def initialize(id)
        self.id = id
      end

      def id=(id)
        fail 'Image.id has to be a string and can not be empty!' unless id.is_a?(String) && !id.empty?
        @id = id
      end

      def metadata=(metadata)
        fail 'Hash expected' if metadata.class != Hash
        fail 'Image does not have an ID' unless metadata['id']
        fail 'Image ID mismatch' unless metadata['id'] == id
        fail 'Metadata has to contain containter_config' unless metadata.key? 'container_config'
        @metadata = metadata
      end

      def checksum=(checksum)
        fail 'Invalid checksum!' unless !!checksum && checksum.length == 71 && checksum.include?('sha256:') && !!checksum.sub(/sha256:/, '').match(/[a-f]+/)
        @checksum = checksum
      end
    end
  end
end
