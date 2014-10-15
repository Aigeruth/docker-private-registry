require 'grape-swagger'

module DockerRegistry
  DEFAULT_SWAGGER_OPTIONS = {
    mount_path: 'doc',
    format: :json,
    markdown: GrapeSwagger::Markdown::RedcarpetAdapter.new(render_options: { highlighter: :rouge }),
    hide_format: true,
    hide_documentation_path: true
  }
end
