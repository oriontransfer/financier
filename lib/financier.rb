# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require "utopia"

require "xrb"
require "xrb/uri"

require "yaml"

require_relative "financier/database"

require_relative "financier/account"
require_relative "financier/address"
require_relative "financier/company"
require_relative "financier/customer"
require_relative "financier/invoice"
require_relative "financier/service"
require_relative "financier/timesheet"
require_relative "financier/billing"

require_relative "financier/calendar"

require_relative "financier/view_formatter"
require_relative "financier/form_formatter"
require_relative "financier/user"

require "ofx"
require "qif"
require "csv"

require "bigdecimal"

# A monkey patch to fix ofx:
class BigDecimal
	def self.new(*arguments)
		BigDecimal(*arguments)
	end
end

CSV::Converters[:blank_to_nil] = lambda do |field|
	field && field.empty? ? nil : field
end
