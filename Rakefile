# frozen_string_literal: true
require 'rubocop/rake_task'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'
require 'rdoc/task'

desc 'Run linter and tests'
task default: %i(rubocop test)

RDoc::Task.new do |t|
  t.main = 'README.md'
  t.rdoc_dir = 'doc'
  t.rdoc_files.include('README.md', 'lib/**/*.rb')
end
RuboCop::RakeTask.new
Rake::TestTask.new do |t|
  t.libs << 'test'
end

spec_path = File.expand_path('../coder_decorator.gemspec', __FILE__)
spec = Gem::Specification.load(spec_path)
Gem::PackageTask.new(spec).define
