# frozen_string_literal: true
require 'rubocop/rake_task'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'

desc 'Run linter and tests'
task default: %i(rubocop test)

RuboCop::RakeTask.new
Rake::TestTask.new do |t|
  t.libs << 'test'
end

spec_path = File.expand_path('../coders.gemspec', __FILE__)
spec = Gem::Specification.load(spec_path)
Gem::PackageTask.new(spec).define
