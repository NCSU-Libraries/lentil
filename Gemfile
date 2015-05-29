source "https://rubygems.org"
require 'yaml'

# Declare your gem's dependencies in lentil.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development do
  gem 'rb-readline'
  gem 'guard'
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
end

group :tools do
  gem 'guard-test'
end

# Configuration to install correct DB adapter
env = ENV["RAILS_ENV"] || 'development'
dbconfig = File.expand_path("../config/database.yml", __FILE__)

raise "You need to configure config/database.yml first" unless File.exists?(dbconfig)
require 'erb'
config = YAML.load(ERB.new(File.read(dbconfig)).result)

environment = config[env]

adapter = environment['adapter'] if environment
raise "Please set an adapter in database.yml for #{env} environment" if adapter.nil?
case adapter
when 'sqlite3'
  gem 'sqlite3'
when 'postgresql'
  gem 'pg'
when 'mysql2'
  gem 'mysql2'
else
  raise "Not supported database adapter: #{adapter}"
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
