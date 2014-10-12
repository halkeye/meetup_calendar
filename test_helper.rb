# test_helper.rb
if ENV['GENERATE_REPORTS'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    root 'test'
  end
end
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../sinatra.rb', __FILE__
