
require 'bundler/setup'
require 'utopia'

DATABASE_ENV = 'test'
require_relative '../db/environment'

require 'financier'

Bundler.require(:test)

RSpec.configure do |config|
	# Enable flags like --only-failures and --next-failure
	config.example_status_persistence_file_path = '.rspec_status'

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
end
