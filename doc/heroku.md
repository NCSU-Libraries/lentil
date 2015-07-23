# Using lentil on Heroku
This document outlines the basic steps required to deploy lentil to the [Heroku](https://www.heroku.com/) cloud platform. This outline is based on the [lentil](https://github.com/NCSU-Libraries/lentil/blob/master/README.md) and [Getting Started with Rails 3.x on Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails3) documentation.

## Create a new rails app with lentil in your local environment

Create a new rails app using the [lentil installation docs](https://github.com/NCSU-Libraries/lentil/blob/master/README.md#installation). **Please note, there are several differences when creating a Heroku compliant rails application:**

1) When [creating](https://github.com/NCSU-Libraries/lentil/blob/master/README.md#create-a-new-rails-app-with-rails-32x) a new application for lentil, the command should be invoked with a lentil compatible rails version: `rails _3.2.x_ new <name_of_app>`

2) When editing the [Gemfile](https://github.com/NCSU-Libraries/lentil/blob/master/README.md#add-lentil-and-therubyracer-or-another-execjs-runtime-to-your-gemfile-and-bundle), add the following gems in addition to the other modifications listed in the lentil documentation. Note: you may need to delete the `Gemfile.lock` before bundling.

```
ruby '2.1.5'
gem 'rails_12factor', group: :production
gem 'pg', group: :production
```

The gem definition for Sqlite3 should also be modified: `gem 'sqlite3', group: :development`.

3) In `config/application.rb` add:

```
config.assets.initialize_on_precompile = true
config.serve_static_assets = false
```

4) In `config/database.yml` replace the production db definition with:

```
production:
  adapter: postgresql
  encoding: unicode
  database: <name_of_app>_production
  pool: 5
  username: <name_of_app>
  password:
```

## Setup Heroku account and toolbelt

1) Create a Herkou [account]().

2) Install the Heroku [toolbelt](https://toolbelt.heroku.com/) for your operating system.

3) Login to Heroku from the command line using `heroku login`.

## Deploy to Heroku

1) [Store your app](https://devcenter.heroku.com/articles/getting-started-with-rails3#store-your-app-in-git) in git.

2) [Create the app](https://devcenter.heroku.com/articles/getting-started-with-rails3#deploy-your-application-to-heroku) on Heroku by running `heroku create --addons heroku-postgresql` from your application directory.

3) Deploy your code: `git push heroku master`.

4) Run db migrations: `heroku run bundle exec rake db:migrate`

5) Add dummy admin user: `heroku run bundle exec rake lentil:dummy_admin_user`. **Create a new admin user and delete the dummy admin as soon as possible!**

6) Add seed data: `heroku run bundle exec rake db:seed`

7) Ensure your "dyno" is running: `heroku ps:scale web=1`

## Visit your application
[Vist](https://devcenter.heroku.com/articles/getting-started-with-rails3#visit-your-application) your app: `heroku open`.

## Schedule harvesting tasks
There are three [harvesting tasks](https://github.com/NCSU-Libraries/lentil#scheduling-tasks) that should be run regularly. These can be run as `heroku run <harvesting-rake-task>` and automated one of two ways:

1) Using a local cron job to execute the harvesting tasks.

2) Using the Heroku [scheduler](https://devcenter.heroku.com/articles/scheduler) add-on.

## Notes on using Postgres in a local development environment

1) PostgreSQL must be installed (using a package manager or by building from source) and running on your system: `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

2) A PostgreSQL user must be created for your application: `createuser -s -r <name_of_app>`.

3) You may also need to install the pg driver. See `config/database.yml` after creating your rails app for details.

4) When [creating](https://github.com/NCSU-Libraries/lentil/blob/master/README.md#create-a-new-rails-app-with-rails-32x) a new application for lentil, the command should be invoked using the postgresql option and lentil compatible rails version: `rails _3.2.x_ new <name_of_app> --database=postgresql`. You will not need to modify the `config/database.yml` file when using this method.

5) Before running `bundle exec rake lentil:install:migrations` locally, run `bundle exec rake db:create:all` to create the postgresql database.

