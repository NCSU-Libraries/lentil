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
  s.test_files = `git ls-files -- test/*`.split("\n")

  s.add_dependency "rails", "~> 3.2.19"
  s.add_dependency 'jquery-rails', '~> 2.3.0'
  s.add_dependency "activeadmin", '~> 0.6.3'
  s.add_dependency 'devise', "~> 3.2.0"
  s.add_dependency "meta_search", '~> 1.1.3' # for search within admin interface
  s.add_dependency "formtastic", '~> 2.2.1' # simplifies form creation
  s.add_dependency "instagram", "~> 1.1.2" # Interact with the Instagram API
  s.add_dependency "modernizr-rails", "~> 2.7.0" # browser feature detection, used by breakpoint
  s.add_dependency 'fancybox2-rails', '~> 0.2.8' # for image interface overlays
  s.add_dependency 'whenever', '>=0.8.0' # for defining cron jobs
  s.add_dependency 'bootstrap-sass', '~> 2.3.0' # sass version of twitter bootstrap
  s.add_dependency 'will_paginate', '~> 3.0' # adds paging feature to rails models
  s.add_dependency 'state_machine', "~> 1.2.0" # adds state machine for moderation
  s.add_dependency 'ruby-oembed', "~> 0.8.9" # Retrieve OEmbed data
  s.add_dependency 'chosen-rails', "~> 1.0.1" # improved form select box
  s.add_dependency 'randumb', "~> 0.4.1" # pull random records from Active Record
  s.add_dependency 'lazing', "~> 0.1.1" # Lazy equivalents for many of the methods defined in Ruby's Enumerable module
  s.add_dependency 'sitemap_generator', "~> 4.3.0" # Generate sitemaps on deployment
  s.add_dependency 'compass-rails', "~> 1.0.3"
  s.add_dependency 'google-analytics-rails', "~> 0.0.4"
  s.add_dependency 'typhoeus', "~> 0.6.6" # for checking and harvesting image files
  s.add_dependency 'kaminari', "~> 0.14.1" # for checking and harvesting image files

  s.add_development_dependency "sqlite3", "~> 1.3.8"
  s.add_development_dependency "capybara", "~> 2.1.0"
  s.add_development_dependency "database_cleaner", "~> 1.0.0"
  s.add_development_dependency "launchy", "~> 2.4.0"
  s.add_development_dependency "vcr", "~> 2.7.0"
  s.add_development_dependency "webmock", "< 1.16"
  s.add_development_dependency "simplecov", "~> 0.8.2"
  s.add_development_dependency "pry-rails", "~> 0.3.2"
  s.add_development_dependency "test-unit", "~> 2.5.5"
  s.add_development_dependency "mocha", "~> 0.14.0"
  s.add_development_dependency "single_test", "~> 0.6.0"
  s.add_development_dependency "capybara-webkit", "~> 1.1.0"
  s.add_development_dependency "yard", "~> 0.8.7"
end
