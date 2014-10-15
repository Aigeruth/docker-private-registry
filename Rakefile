require 'rake'
require_relative 'app'

begin
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new

  task default: :spec
  RSpec::Core::RakeTask.new :spec

  namespace :spec do
    desc 'Run RSpec on spec/unit directory'
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = FileList['spec/unit/**/**_spec.rb']
    end

    desc 'Run Spec on spec/api directory'
    RSpec::Core::RakeTask.new(:api) do |t|
      t.pattern = FileList['spec/api/**/**_spec.rb']
    end

    desc 'Run integration test with Vagrant'
    task :integration do
      vagrant_path = File.join File.dirname(__FILE__), 'spec', 'integration'

      sh "cd #{vagrant_path} && vagrant status | grep -e 'default\\s*running'" do |status, _result|
        sh "cd #{vagrant_path} && vagrant up --no-provision" unless status
        sh "cd #{vagrant_path} && vagrant provision"
      end
      sh "cd #{vagrant_path} && vagrant halt"
    end
  end
rescue LoadError; end # rubocop:disable HandleExceptions

desc 'List all available routes'
task :routes do
  DockerRegistry::API.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path.sub(/\(.:format\)/, '')
    puts "     #{method} #{path}"
  end
end
