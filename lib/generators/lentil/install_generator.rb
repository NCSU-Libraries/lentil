module Lentil
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'remove public/index.html'
      def remove_public_index
        remove_file('public/index.html')
      end

      desc 'insert lentil config comments'
      def lentil_config_comments
        insert_into_file "config/application.rb", "\n    # Inserted by lentil\n    # End of lentil changes\n\n", :after => "class Application < Rails::Application\n"
      end

      desc "Remove test/performance/browsing_test.rb"
      def remove_test_performance_browsing_test
        remove_file("test/performance/browsing_test.rb")
      end

      desc "Remove gems"
      def lentil_remove_gems
        gsub_file "Gemfile", /^.*rails-perftest.*$/, ""
        gsub_file "Gemfile", /^.*ruby-prof.*$/, ""
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

      desc 'precompile additional assets'
      def precompile_assets
        append_to_file "config/initializers/assets.rb", "Rails.application.config.assets.precompile += %w( *.js ^[^_]*.css *.css.erb lentil/iframe.js lentil/iframe.css addanimatedimages.js )\n"
      end

      desc 'do not enforce available locales'
      def set_enforce_available_locales
        insert_into_file "config/application.rb", "    I18n.enforce_available_locales = true\n", :after => "# Inserted by lentil\n"
      end

      desc 'install migrations'
      def install_migrations
        rake "lentil:install:migrations"
        rake "db:migrate"
      end

      desc 'include and load seeds'
      def load_seeds
        append_to_file 'db/seeds.rb', "\nLentil::Engine.load_seed\n"
        rake "db:seed"
      end

      desc 'install_devise_files'
      def install_devise_files
        generate 'devise:install'
      end

      desc 'install active_admin'
      def install_active_admin
        copy_file 'active_admin.rb', 'config/initializers/active_admin.rb'
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

      desc 'create application configuration file'
      def lentil_config_yml
        copy_file 'lentil_config.yml', 'config/lentil_config.yml'
      end

      desc 'create kaminari initializer'
      def kaminari_initializer
        copy_file 'kaminari.rb', 'config/initializers/kaminari.rb'
      end

      desc 'add styles'
      def add_styles
        remove_file 'app/assets/stylesheets/application.css'
        create_file 'app/assets/stylesheets/application.css.scss', %Q|@import "lentil";\n|
      end

      desc 'add javascript'
      def add_javascript
        gsub_file('app/assets/javascripts/application.js', '//= require_tree .',
                 '//= require lentil')
      end

      desc 'disable turbolinks'
      def disable_turbolinks
        gsub_file "app/assets/javascripts/application.js", "//= require turbolinks", ""
        gsub_file "Gemfile", /^.*turbolinks.*$/, ""
      end

      desc 'add a dummy admin user to the development database?'
      def dummy_admin_user
        if yes?("Do you want to create an admin user in development now?")
          rake "lentil:dummy_admin_user"
          say "Username: admin@example.com, Password: password"
        else
          say "See the README.md for how to create an admin user."
        end
      end

      desc 'display messages about what needs to be configured'
      def configuration_messages
        file = File.read(File.join( File.expand_path('../templates', __FILE__), 'README.md'))
        say file
      end

    end
  end
end
