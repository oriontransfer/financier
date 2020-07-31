# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
	gem 'guard-falcon', require: false
	gem 'guard-rspec', require: false
	
	gem 'async-rspec'
	gem 'benchmark-http'
end
