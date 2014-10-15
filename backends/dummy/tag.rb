module DockerRegistry
  module Backends
    class DummyTag < BaseTag
      def save; end
    end
  end
end
