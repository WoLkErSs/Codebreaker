# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

group :development do
  gem 'fasterer'
  gem 'pry'
  gem 'rubocop', '~> 0.60.0', require: false
  gem 'rubocop-rspec'
  gem 'i18n'
  gem 'terminal-table'
end

group :test do
  gem "rspec", "~> 3.8"
  gem 'simplecov', require: false, group: :test
  gem 'simplecov-lcov'
  gem 'undercover'
end
