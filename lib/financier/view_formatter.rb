
require 'trenni/formatters'
require 'trenni/formatters/markdown'
require 'trenni/formatters/relative_time'

require "date"

require_relative "database"

module Financier
	class ViewFormatter < Trenni::Formatters::Formatter
		include Trenni::Formatters::Markdown, Trenni::Formatters::RelativeTime
		
		map(Latinum::Resource) do |object, options|
			BANK.format(object, options)
		end
		
		map(Date) do |object, options|
			object.strftime
		end
		
		map(BigDecimal) do |object, options|
			object.to_s('F')
		end
		
		def quantity(transaction)
			if transaction.unit?
				"#{transaction.quantity.to_s('F')} #{transaction.unit}"
			else
				transaction.quantity.to_s('F')
			end
		end

		def tax(object)
			(object.tax_rate * 100.to_d).to_s('F') + '%'
		end
	end
end
