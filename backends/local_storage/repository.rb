require 'fileutils'
require 'active_support'

module DockerRegistry
  module Backends
    class LocalStorageRepository < BaseRepository
      PREFIX = 'repositories'

      def path
        @path ||= File.join self.class.path_prefix, namespace, name
      end

      def metadata_path
        @metadata_path ||= File.join path, 'json'
      end

      def metadata_exist?
        File.exist? metadata_path
      end

      def exist?
        Dir.exist?(path) && metadata_exist?
      end

      def create
        FileUtils.mkdir_p path
      end

      def delete!
        FileUtils.rm_r path
      end

      def metadata
        @metadata ||= load_metadata
      end

      def load_metadata
        ActiveSupport::JSON.decode IO.read(metadata_path) if metadata_exist?
      end

      def metadata=(metadata)
        super(metadata)
        create
        IO.write metadata_path, ActiveSupport::JSON.encode(metadata)
      end

      def tag(name, image = nil)
        LocalStorageTag.new name, self, image
      end

      def tags
        Hash.new.tap do |tags|
          Dir.glob(File.join(path, 'tags', '*')).map do |name|
            name = File.basename name
            tags[name] = tag(name).image.id
          end
        end
      end

      class << self
        def path_prefix
          File.join LocalStorageBackend.storage_path, PREFIX
        end

        def all
          repositories = Dir.glob(File.join path_prefix, '*', '*')
          repositories.map! { |dir| dir.sub path_prefix + File::SEPARATOR, '' }
          repositories.map do |path|
            namespace, name = path.split File::SEPARATOR
            new namespace, name
          end
        end
      end
    end
  end
end
