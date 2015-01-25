# A sample Gemfile
source 'https://rubygems.org'

ruby '2.1.5'

gem 'sinatra', '~> 1.4.5'
gem 'sinatra-contrib', '~> 1.4.2'
gem 'haml', '~> 4.0.5'
gem 'grape', '~> 0.9.0'
gem 'grape-swagger', '~> 0.8.0'
gem 'redcarpet'
gem 'rouge'
gem 'rake'
gem 'faker', '~> 1.4.3'

group :lint do
  gem 'rubocop', '~> 0.28'
end

group :development do
  gem 'rerun', '~> 0.10.0'
  gem 'guard-rubocop', '~> 1.2.0'
  gem 'guard-rspec', '~> 4.5.0'

  # Notification
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin')
  gem 'rb-inotify', require: RUBY_PLATFORM.include?('linux')
  gem 'yard', '~> 0.8.7.4'
end

group :test do
  gem 'simplecov', '~> 0.9.0'
  gem 'coveralls', '~> 0.7.0'
  gem 'rspec', '~> 3.1.0'
  gem 'rspec-its', '~> 1.1.0'
  gem 'rack-test', '~> 0.6.2'
  gem 'json_spec', '~> 1.1.2'
end

gem 'unicorn', '~> 4.8.3'
