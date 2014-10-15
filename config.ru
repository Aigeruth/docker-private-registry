require_relative 'app'

run Rack::Cascade.new [
  DockerRegistry::API,
  DockerRegistry::App
]
