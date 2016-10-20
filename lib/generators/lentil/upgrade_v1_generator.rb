module Lentil
  module Generators
    class UpgradeV1Generator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc "Remove test/performance/browsing_test.rb"
      def remove_test_performance_browsing_test
        remove_file("test/performance/browsing_test.rb")
      end

      desc "Update gems"
      def lentil_update_gems
        gsub_file "Gemfile", /^.*sass-rails.*$/, "gem 'sass-rails'"
        gsub_file "Gemfile", /^.*coffee-rails.*$/, "gem 'coffee-rails'"
      end

      desc "Remove gems"
      def lentil_remove_gems
        gsub_file "Gemfile", /^.*rails-perftest.*$/, ""
        gsub_file "Gemfile", /^.*ruby-prof.*$/, ""
      end

      desc "Enable raise_in_transactions_callbacks"
      def enable_raise_trans_cb
        insert_into_file "config/application.rb", "    config.active_record.raise_in_transactional_callbacks = true", :after => "# Inserted by lentil\n"
      end

      desc "Randomize tests"
      def randomize_tests
        insert_into_file "config/environments/test.rb", "    config.active_support.test_order = :random", :before => "end"
      end

      desc "Update precompilation paths"
      def update_precompilation_paths
        gsub_file "config/application.rb", /^.*Rails.application.config.assets.precompile.*$/, ""
        append_to_file "config/initializers/assets.rb", "Rails.application.config.assets.precompile += %w( *.js ^[^_]*.css *.css.erb lentil/iframe.js lentil/iframe.css addanimatedimages.js animatedimages/css/style.css )\n"
      end

      desc 'insert routes'
      def insert_routes
        routes = <<-ROUTES

  root :to => 'lentil/images#index'
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(:class_name => 'Lentil::AdminUser')
  ActiveAdmin.routes(self)
  mount Lentil::Engine => "/"

ROUTES
        insert_into_file "config/routes.rb", routes, :after => "Rails.application.routes.draw do\n"
      end

    end
  end
end
