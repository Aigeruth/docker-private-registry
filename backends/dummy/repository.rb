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
        { 'latest' => 'db7661edb9a2045e5a4fa90010bdb66c4623338b17d7393e72e6e32f831282a8' }
      end

      class << self
        def all
          10.times.map { new("#{Faker::Name.first_name.downcase}_#{Faker::Name.last_name.downcase}", Faker::App.name.downcase) }
        end
      end
    end
  end
end
