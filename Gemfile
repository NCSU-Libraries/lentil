source "https://rubygems.org"
require 'yaml'
require 'erb'

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

group :test do
  gem 'mysql2', '~> 0.3.20'
  gem 'pg'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
