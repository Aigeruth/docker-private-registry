ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'rspec/its'
require 'rack/test'
require 'json_spec'
require_relative 'support/backend_interface'
require_relative 'support/repository_interface'
require_relative 'support/image_interface'
require_relative 'support/tag_interface'

RSpec.configure do |config|
  config.include JsonSpec::Helpers
end

require_relative '../app'
