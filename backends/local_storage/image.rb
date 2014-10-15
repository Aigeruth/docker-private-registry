require 'fileutils'
require 'digest'
require 'active_support'

module DockerRegistry
  module Backends
    class LocalStorageImage < BaseImage
      PREFIX = 'images'

      def path
        File.join LocalStorageBackend.storage_path, PREFIX, id
      end

      def metadata_path
        File.join path, 'json'
      end

      def layer_path
        File.join path, 'layer'
      end

      def checksum_path
        File.join path, 'checksum'
      end

      def create
        FileUtils.mkdir_p path
      end

      def delete!
        FileUtils.rm_r path
      end

      def metadata
        @metadata || load_metadata
      end

      def load_metadata
        @metadata = load_json metadata_path if metadata_exist?
      end

      def checksum
        @checksum || load_checksum
      end

      def load_checksum
        self.checksum = load_json checksum_path if checksum_exist?
      end

      def metadata_exist?
        File.exist? metadata_path
      end

      def layer_exist?
        File.exist? layer_path
      end

      def checksum_exist?
        File.exist? checksum_path
      end

      def exist?
        metadata_exist? && layer_exist?
      end

      def layer
        IO.binread layer_path if layer_exist?
      end

      def layer=(data)
        IO.binwrite layer_path, data
        save_json checksum_path, "sha256:#{calculate_checksum}"
      end

      def size
        File.size?(layer_path) || 0
      end

      def metadata=(metadata)
        super(metadata)
        create
        save_json metadata_path, metadata
      end

      def ancestry
        parents.map(&:id).unshift(id)
      end

      def calculate_checksum
        checksum = Digest::SHA256.new
        checksum << IO.read(metadata_path) + "\n"
        checksum << IO.binread(layer_path)
        checksum.hexdigest
      end

      def parents
        parent && parent.parents.unshift(parent) || []
      end

      def parent
        metadata['parent'] && self.class.new(metadata['parent'])
      end

      protected

      def load_json(source)
        ActiveSupport::JSON.decode IO.read(source)
      end

      def save_json(destination, content)
        IO.write destination, ActiveSupport::JSON.encode(content)
      end
    end
  end
end
