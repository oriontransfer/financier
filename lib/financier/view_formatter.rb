
require 'trenni/formatters'
require 'trenni/formatters/markdown'
require 'trenni/formatters/relative_time'

require "date"

require_relative "database"

class BigDecimal
	alias _to_s to_s

	def to_s param = nil
		_to_s param || 'F'
	end
end

module Financier
	class ViewFormatter < Trenni::Formatters::Formatter
		include Trenni::Formatters::Markdown, Trenni::Formatters::RelativeTime
		
		map(Latinum::Resource) do |object, options|
			BANK.format(object, options)
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
