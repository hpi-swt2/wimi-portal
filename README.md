# wimi-portal

[![Code Climate](https://codeclimate.com/github/hpi-swt2/wimi-portal/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/wimi-portal)
[![Test Coverage](https://codeclimate.com/github/hpi-swt2/wimi-portal/badges/coverage.svg)](https://codeclimate.com/github/hpi-swt2/wimi-portal/coverage)
[![Build Status](https://travis-ci.org/hpi-swt2/wimi-portal.svg)](https://travis-ci.org/hpi-swt2/wimi-portal)
[![Heroku](https://heroku-badge.herokuapp.com/?app=wimi-portal)](http://wimi-portal.herokuapp.com/)
[![License](http://img.shields.io/badge/license-AGPL-blue.svg)](https://github.com/hpi-swt2/wimi-portal/blob/master/LICENSE)

## Building Status

Branch      | Status
----------- | ----------
master  | [![Build Status](https://travis-ci.org/hpi-swt2/wimi-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/wimi-portal)
dev  | [![Build Status](https://travis-ci.org/hpi-swt2/wimi-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/wimi-portal)

## Heroku Deployment

When TravisCI run all tests successfully, the build is deployed to heroku. This is done for the master branch as well as the dev branch.

Branch      | Heroku App | Status
----------- | ---------- | ----------
master  |  [click here](http://wimi-portal.herokuapp.com/)  | [![Heroku](https://heroku-badge.herokuapp.com/?app=wimi-portal)](http://wimi-portal.herokuapp.com/)
dev  |  [click here](http://wimi-portal-dev.herokuapp.com/)  | [![Heroku](https://heroku-badge.herokuapp.com/?app=wimi-portal-dev)](http://wimi-portal-dev.herokuapp.com/)

## Setup

Install gem bundle with

```bundle install```

select database config (in this case we take the sqlite)

```cp database.sqlite.yml database.yml```

display all available rake tasks

```rake -T```

create a database and run the available migrations

```rake db:create && rake db:migrate```

then we can run either the rails console with

```rails c```

or the rails server with

```rails s```

in case you want to run all tests go ahead and execute

```rspec .``` 

or by specifing the exact spec file with

```rspec spec/controller/expenses_controller_spec.rb```


