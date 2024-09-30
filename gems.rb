# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :test do
	gem 'sus'
	gem 'covered'
	
	gem "falcon"
	gem 'rack-test'
	gem 'sus-fixtures-async-http'
	
	gem 'benchmark-http'
	gem 'io-watch'
	
	gem 'bake-test'
end
