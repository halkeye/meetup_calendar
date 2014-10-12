require './sinatra'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

if ENV['GENERATE_REPORTS'] == 'true'
  require 'ci/reporter/rake/minitest'
  task :test => 'ci:setup:minitest'
end

task default: %w[test]
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = true
end
