# A sample Gemfile
source 'https://rubygems.org'

gem 'activesupport'
gem 'icalendar'
gem 'omniauth-meetup'
gem 'rake'
gem 'rMeetup', :git => 'https://github.com/carpeliam/rmeetup'
gem 'sinatra'
gem 'sinatra-activerecord'

group :production do
  gem 'pg'
end

group :test do
  gem 'ci_reporter_minitest', '~> 1.0.0'
  gem 'simplecov', :require => false

  gem 'minitest'
  gem 'rack-test'
end

group :development do
  gem 'better_errors'
  gem 'sqlite3'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rack'
end
