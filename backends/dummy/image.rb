require 'active_support'
require 'active_support/core_ext'
require 'zlib'
require 'stringio'

module DockerRegistry
  module Backends
    class DummyImage < BaseImage
      attr_reader :id

      def initialize(id)
        self.id = id
        exist? && metadata && checksum
      end

      def id=(id)
        fail 'Image.id has to be a string and can not be empty!' unless id.is_a?(String) && !id.empty?
        @id = id
      end

      def exist?
        true
      end

      def delete!; end

      def metadata
        { 'id' => 'dummy_id', 'container_config' => {} }
      end

      def checksum
        'sha256:' + 'a' * 64
      end

      def layer
        gzipped_layer.string
      end

      def layer=(_data); end

      def size
        gzipped_layer.size
      end

      def ancestry
        ['dummy_id']
      end

      private

      def gzipped_layer
        StringIO.new.tap do |l|
          gz = Zlib::GzipWriter.new l
          gz.write "\0" * 1024
          gz.close
        end
      end
    end
  end
end
