require 'active_support/core_ext'
require 'faker'

module DockerRegistry
  module Backends
    class DummyRepository < BaseRepository
      def exist?
        true
      end

      def delete!; end

      def images
        [{ id: 'id' }]
      end

      def tag(_name, _image)
        DummyTag.new 'latest', self, DummyImage.new('dummy_id')
      end

      def tags
        { 'latest' => 'dummy_id' }
      end

      class << self
        def all
          10.times.map { new("#{Faker::Name.first_name.downcase}_#{Faker::Name.last_name.downcase}", Faker::App.name.downcase) }
        end
      end
    end
  end
end
