require './sinatra'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

task default: %w[test]
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = true
end
