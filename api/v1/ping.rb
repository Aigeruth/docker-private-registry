module DockerRegistry
  module V1
    class PingAPI < ::Grape::API
      resource :_ping, desc: 'Service status' do
        desc 'Service status'
        get do
          header 'X-Docker-Registry-Version', VERSION
          header 'X-Docker-Registry-Config', ''
          header 'X-Docker-Registry-Standalone', 'true'
          { standalone: true }
        end
      end
    end
  end
end
