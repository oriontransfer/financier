# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require "variant"
require "relaxo"
require "console"

module Financier
	DATABASE_PATH = File.join(__dir__, Variant.for(:database).to_s)
	
	# Configure the database connection:
	DB = Relaxo.connect(DATABASE_PATH, logger: Console.logger)
end
