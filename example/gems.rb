# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

source "https://rubygems.org"

group :preload do
	gem "bake"
	
	# gem "financier", git: "https://github.com/oriontransfer/financier"
	gem "financier", path: "../"
end

group :production do
	gem "falcon"
end

group :development do
	gem "guard"
	gem "guard-falcon"
end
