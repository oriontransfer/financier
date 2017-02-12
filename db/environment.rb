
DATABASE_ENV = (ENV['DATABASE_ENV'] || RACK_ENV || :development).to_s

require 'relaxo'

module Financier
	DATABASE_PATH = File.join(__dir__, DATABASE_ENV)
	
	# Configure the database connection:
	DB = Relaxo.connect(DATABASE_PATH, logger: Logger.new($stderr))
end
