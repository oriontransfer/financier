
require 'financier/formatter'

module Financier
	class ViewFormatter < Formatter
		def initialize(options = {})
			super(options)
			
			formatter_for(Latinum::Resource) do |object, options|
				self.resource(object)
			end
		end
		
		def markdown(text)
			MARKDOWN.render(text)
		end

		def resource(resource)
			BANK.format(resource).to_html
		end

		def quantity(transaction)
			if transaction.unit
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
