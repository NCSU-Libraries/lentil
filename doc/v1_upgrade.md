# Lentil 1.0.0 upgrade

* Update application gemfile
  * Change: gem ‘lentil’, ‘~> 1.0’
  * Change: gem ‘rails’, ‘~> 4.2’
* Run `bundle update`
* Run `bundle exec rake rails:update` to generate Rails 4 configuration files
* Move data from `config/initializers/secret_token.yml` to `config/secrets.yml`. See http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#config-secrets-yml
* Run `bundle exec rails generate lentil:upgrade_v1`
