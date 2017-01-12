
require 'trenni/formatters'

require "redcarpet"
#require "kramdown"
require "date"

require_relative "database"

require 'redcarpet'

class BigDecimal
	alias _to_s to_s

	def to_s param = nil
		_to_s param || 'F'
	end
end

module Financier
	MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
	
	class ViewFormatter < Trenni::Formatters::Formatter
		map(Latinum::Resource) do |object, options|
			BANK.format(object, options)
		end
			
		def markdown(text)
			MARKDOWN.render(text)
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
