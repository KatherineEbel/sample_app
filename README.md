#  Ruby on Rals Tutorial Sample App

This is the sample application for the
[Ruby on Rails Tutorial](https://www.railstutorial.org)
by [Michael Hartl](https://www.michaelhartl.com/).

* Ruby version 3.1.2
* Rails version 7.0.3.1

## Getting started

clone the repo and then install gems:

```shell
gem install bundler
bundle config set --local without 'production'
bundle install
```

migrate the database:

```shell
rails db:migrate
```

run the test suite

```shell
rails test
```

if tests pass, run server

```shell
rails server
```