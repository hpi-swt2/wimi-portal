# WiMi-Portal
A Ruby on Rails app for managing time sheets of [student assistants](https://de.wikipedia.org/wiki/Wissenschaftliche_Hilfskraft)

[![License](http://img.shields.io/badge/license-AGPL-blue.svg)](https://github.com/hpi-swt2/wimi-portal/blob/master/LICENSE)

Branch | Travis CI  | Code Analysis | Heroku Deploy | Errbit
------ | ---------- | ------------- | ------------- | ------
master  | [![Build Status](https://travis-ci.org/hpi-swt2/wimi-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/wimi-portal) | [![Code Climate](https://codeclimate.com/github/hpi-swt2/wimi-portal/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/wimi-portal) [![Test Coverage](https://codeclimate.com/github/hpi-swt2/wimi-portal/badges/coverage.svg)](https://codeclimate.com/github/hpi-swt2/wimi-portal/coverage) | [![Heroku](https://heroku-badge.herokuapp.com/?app=wimi-portal)](http://wimi-portal.herokuapp.com/) [[deployed app]](http://wimi-portal.herokuapp.com/) | [[link]](http://swt2-2015-errbit.herokuapp.com/)
dev  | [![Build Status](https://travis-ci.org/hpi-swt2/wimi-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/wimi-portal) | [[codeclimate diff to master]](https://codeclimate.com/github/hpi-swt2/wimi-portal/compare/dev) | [![Heroku](https://heroku-badge.herokuapp.com/?app=wimi-portal-dev)](http://wimi-portal-dev.herokuapp.com/) [[deployed app]](http://wimi-portal-dev.herokuapp.com/)

When TravisCI run all tests successfully, the build is deployed to heroku. This is done for the master branch as well as the dev branch.

## Local Setup

* `bundle install` Install the required Ruby gem dependencies defined in the [Gemfile](https://github.com/hpi-swt2/workshop-portal/blob/production/Gemfile)
* `cp database.sqlite.yml database.yml` Select database config (for development we recommend SQLite) 
* `rake db:create db:migrate db:seed` Setup database, run migrations, seed the database with defaults
* `rails s` Start the Rails development server (By default runs on _localhost:3000_)
* `bundle exec rspec` Run all the tests (using the [RSpec](http://rspec.info/) test framework)

## Setup using Vagrant (Virtual Machine)

If you want to use a VM to setup the project (e.g. when on Windows), we recommend [Vagrant](https://www.vagrantup.com/).
Please keep in mind that this method may lead to a loss in performance, due to the added abstraction layer.

```
vagrant up # bring up the VM
vagrant ssh # login using SSH
cd hpi-swt2
echo "gem: --no-document" >> ~/.gemrc # disable docs for gems
bundle install # install dependencies
gem install pg # required for Postgres usage
cp config/database.psql.yml config/database.yml # in case you want to use Postgres
cp config/database.sqlite.yml config/database.yml # in case you want to user SQLite
exit # restart the session, required step
vagrant ssh # reconnect to the VM
cd hpi-swt2
rails s -b 0 # start the rails server
# the -b part is necessary since the app is running in a VM and would
# otherwise drop the requests coming from the host OS
```

## Deploy

The following environment variables should be set:

* `HOST`
* `SECRET_KEY_BASE`
* `EMAIL_PW`
* `EMAIL_USER`

## Important Development Commands
* `bundle exec rake db:migrate && bundle exec rake db:migrate RAILS_ENV=test` Migrate dbs
* `bundle exec rake assets:clobber && bundle exec rake assets:precompile` Redo asset generation
* `bundle exec rspec spec/<rest_of_file_path>.rb` Specify a folder or test file to run
* `rails c --sandbox` Test out some code in the Rails console without changing any data
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_.
* `rails dbconsole` Starts the CLI of the database you're using
* `bundle exec rake routes` Show all the routes (and their names) of the application
* `bundle exec rake about` Show stats on current Rails installation, including version numbers
* `bundle exec rspec --profile` examine how much time individual tests take
