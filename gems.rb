# frozen_string_literal: true

source 'https://rubygems.org'

group :preload do
	gem 'utopia', '~> 2.18.0'
	# gem 'utopia-gallery'
	# gem 'utopia-analytics'
	
	gem 'variant'
	
	gem "relaxo", "~> 1.3"
	gem "relaxo-model", "~> 0.15.0"
	
	gem "periodical", "~> 1.0"
	gem "latinum", "~> 1.3"

	gem "time-zone", "~> 1.1"

	gem "ofx", "~> 0.3", git: "https://github.com/annacruz/ofx"
	gem "qif", "~> 1.1"

	gem "sanitize"
	gem "kramdown"
	gem "bcrypt", "~> 3.0"
	
	gem "trenni-formatters"
	gem "markly"

	gem "tty-prompt"
end

gem 'rake'
gem 'bake'
gem 'bundler'
gem 'rack-test'

group :development do
	gem 'guard-falcon', require: false
	gem 'guard-rspec', require: false
	
	gem 'rspec'
	gem 'covered'
	
	gem 'async-rspec'
	gem 'benchmark-http'
end

group :production do
	gem 'falcon'
end
