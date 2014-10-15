module DockerRegistry
  module V1
    class RepositoryAPI < ::Grape::API
      helpers do
        def token(repository, access)
          signature = SecureRandom.base64 16
          %(Token signature=#{signature},repository="#{repository.namespace}/#{repository.name}",access=#{access})
        end

        def index_endpoint
          env['SERVER_NAME'].dup.tap do |host|
            port = env['SERVER_PORT']
            host << ":#{port}" if port && ![80, 443].include?(port.to_i)
          end
        end

        def update_metadata(metadata)
          repository.metadata = metadata
        rescue RuntimeError => e
          error! e.message, 400
        end
      end

      resource :repositories do
        params do
          optional :namespace, type: String, default: 'library', desc: 'Repository namespace'
          requires :repository, type: String, desc: 'Repository name'
        end

        # Currently Grape does not support to mount an API class two times.
        # Related issue: https://github.com/intridea/grape/issues/570
        # route_param :repository do
        #   mount RepositoryAPI => '/'
        # end
        # This Docker Registry implementation does not support implicit
        # namespace for `library` (e.g. docker pull ubuntu)

        route_param :namespace do
          route_param :repository do
            desc 'Get repository metadata', http_codes: [[404, 'Repository does not exist']]
            get do
              error! 'Repository does not exist!', 404 unless repository.exist?
              repository.images
            end

            desc 'Upload a repository'
            put do
              update_metadata env['api.request.body']
              token = token(repository, 'write')
              header 'X-Docker-Endpoints', index_endpoint
              header 'WWW-Authenticate', token
              header 'X-Docker-Token', token(repository, 'write')
            end

            # Could be at the top if :except would be supported.
            # https://github.com/intridea/grape/issues/39
            after_validation do
              error! 'Repository does not exist!', 404 unless repository.exist?
            end

            desc 'Delete a repository', http_codes: [[404, 'Repository does not exists']]
            delete do
              repository.delete!
            end

            resource :images do
              desc 'Get repository metadata', http_codes: [[404, 'Repository does not exists']]
              get do
                repository.images
              end

              desc 'List of images in the repository',
                   http_codes: [
                     [204, 'Repository updated'],
                     [400, 'Invalid metadata']
                   ]
              put do
                update_metadata env['api.request.body']
                status 204
              end
            end

            resource :tags do
              desc 'Get repository tags', http_codes: [[404, 'Repository does not exists']]
              get do
                repository.tags
              end

              desc 'Create or update a repository tag', http_codes: [[404, 'Repository does not exists']]
              params do
                requires :tag, type: String, desc: 'Tag name (e.g. "latest")'
              end
              put ':tag' do
                repository.tag(params[:tag], image(env['api.request.body'])).save
              end
            end
          end
        end
      end
    end
  end
end
