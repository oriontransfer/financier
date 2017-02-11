
source "https://rubygems.org"

gem "utopia", "~> 1.9.10"
# gem "utopia-tags-gallery"
# gem "utopia-tags-google-analytics"

gem "relaxo", "~> 0.6"
gem "relaxo-model", "~> 0.6"
gem 'rugged', git: 'git://github.com/libgit2/rugged.git', submodules: true

gem "trenni-formatters", "~> 2.4"

gem "periodical", "~> 1.0"
gem "latinum", "~> 1.1"

gem "ofx", "~> 0.3"
gem "qif", "~> 1.1"

gem "sanitize"
gem "kramdown"
gem "bcrypt", "~> 3.0"

gem "rake"
gem "bundler"

group :development do
	# For `rake server`:
	gem "puma"
	
	# For `rake console`:
	gem "pry"
	gem "rack-test"
	
	# For `rspec` testing:
	gem "rspec"
	gem "simplecov"
end

group :production do
	# Used for passenger-config to restart server after deployment:
	gem "passenger"
end
