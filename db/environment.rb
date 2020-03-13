
require 'variant'
require 'relaxo'

module Financier
	DATABASE_PATH = File.join(__dir__, Variant.for(:database))
	
	# Configure the database connection:
	DB = Relaxo.connect(DATABASE_PATH, logger: Logger.new($stderr))
end
