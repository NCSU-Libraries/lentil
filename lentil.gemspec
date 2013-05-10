$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lentil/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lentil"
  s.version     = Lentil::VERSION
  s.authors     = ["Jason Casden", "Cory Lown", "Bret Davidson", "Jason Ronallo"]
  s.email       = ["lentil@lists.ncsu.edu"]
  s.homepage    = "https://github.com/NCSU-Libraries/lentil"
  s.license     = "MIT"
  s.summary     = "lentil supports the harvesting of images from Instagram."
  s.description = "lentil supports the harvesting of images from Instagram and provides several browsing views, mechanisms for sharing, tools for users to select their favorite images, an administrative interface for moderating images, and a system for harvesting images and submitting donor agreements in preparation of ingest into external repositories. Built according to the principles of 'responsive design, lentil is designed for use on mobile devices, tablets, desktops, and larger screens. This project is extracted from the My #HuntLibrary project at NCSU Libraries."

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "activeadmin", "0.5.1"
  s.add_dependency "meta_search" # for search within admin interface
  s.add_dependency "formtastic" # simplifies form creation
  s.add_dependency "instagram", "~> 0.10.0" # Interact with the Instagram API
  s.add_dependency "modernizr-rails" # browser feature detection, used by breakpoint
  s.add_dependency 'fancybox2-rails', '~> 0.2.1' # for image interface overlays
  s.add_dependency 'whenever', '>=0.8.0' # for defining cron jobs
  s.add_dependency 'bootstrap-sass' # sass version of twitter bootstrap
  s.add_dependency 'will_paginate', '~>3.0' # adds paging feature to rails models
  s.add_dependency 'state_machine' # adds state machine for moderation
  s.add_dependency 'ruby-oembed' # Retrieve OEmbed data
  s.add_dependency 'chosen-rails' # improved form select box
  s.add_dependency 'randumb' # pull random records from Active Record
  s.add_dependency 'lazing' # Lazy equivalents for many of the methods defined in Ruby's Enumerable module
  s.add_dependency 'sitemap_generator' # Generate sitemaps on deployment
  s.add_dependency 'compass-rails'
  s.add_dependency 'google-analytics-rails'
  s.add_dependency 'typhoeus' # for checking and harvesting image files

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara", "~> 2.0.2"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "launchy"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock", "< 1.10.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "mocha"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "single_test"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "yard"
end
