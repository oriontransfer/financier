# frozen_string_literal: true

source 'https://rubygems.org'

group :preload do
	gem "bake"
	
	gem "financier", git: "https://github.com/oriontransfer/financier"
	# gem "financier", path: "../"
end

group :production do
	gem 'falcon'
end

group :development do
	gem 'guard'
	gem 'guard-falcon'
end
