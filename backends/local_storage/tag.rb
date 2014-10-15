require 'fileutils'

module DockerRegistry
  module Backends
    class LocalStorageTag < BaseTag
      def containter_path
        File.join repository.path, 'tags'
      end

      def path
        File.join containter_path, name
      end

      def exist?
        File.exist? path
      end

      def image
        @image ||= LocalStorageImage.new IO.read(path)
      end

      def save
        fail 'Image can not be nil!' if image.nil?
        FileUtils.mkdir_p containter_path
        File.open(path, 'w') { |f| f.write(image.id) }
      end
    end
  end
end
