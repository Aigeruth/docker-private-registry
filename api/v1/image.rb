module DockerRegistry
  module V1
    class ImageAPI < ::Grape::API
      resource :images do
        params do
          requires :image_id, type: String, desc: 'Image ID (hash)'
        end
        route_param :image_id do
          desc 'Get the metadata of an image'
          get :json do
            error! 'Image not found', 404 unless image.exist?
            image.metadata
          end

          desc 'Upload metadata for an image'
          put :json do
            image.metadata = env['api.request.body']
            body true
          end

          desc 'Check an image layer'
          head :layer do
            error! 'Image layer file does not exist!', 404 unless image.exist?
            env['api.format'] = :binary
            header 'Content-Length', image.size
            body ''
          end

          desc 'Get image layer'
          get :layer do
            error! 'Image layer file does not exist!', 404 unless image.exist?
            header 'Content-Length', image.size
            header 'Content-Encoding', 'gzip'
            env['api.format'] = :binary
            body image.layer
          end

          desc 'Upload an image layer'
          put :layer do
            image.layer = env['rack.input'].read
            body true
          end

          desc 'Upload image checksum'
          put :checksum do
            checksum = headers['X-Docker-Checksum-Payload']
            error! 'Image not found!', 404 unless image.exist?
            error! 'Checksum mismatch!', 400 unless image.checksum == checksum
            body nil
          end

          desc 'Get ancestry of an image'
          get :ancestry do
            image.ancestry
          end
        end
      end
    end
  end
end
