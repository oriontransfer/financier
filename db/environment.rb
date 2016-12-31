
DATABASE_ENV = (ENV['DATABASE_ENV'] || RACK_ENV || :development).to_s

require 'relaxo'

module Financier
	# Configure the database connection:
	DB = Relaxo.connect(DATABASE_ENV)
end
