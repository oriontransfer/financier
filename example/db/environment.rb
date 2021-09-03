
require 'variant'
require 'relaxo'
require 'console'

module Financier
	DATABASE_PATH = File.join(__dir__, Variant.for(:database).to_s)
	
	# Configure the database connection:
	DB = Relaxo.connect(DATABASE_PATH, logger: Console.logger)
end
