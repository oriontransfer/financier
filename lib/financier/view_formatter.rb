# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require "xrb/formatters"
require "xrb/formatters/markdown"
require "xrb/formatters/relative_time"

require "date"

require_relative "database"

module Financier
	class ViewFormatter < XRB::Formatters::Formatter
		include XRB::Formatters::Markdown, XRB::Formatters::RelativeTime
		
		map(Latinum::Resource) do |object, **options|
			BANK.format(object, **options)
		end
		
		map(Latinum::Collection) do |object, **options|
			object.map do |resource|
				self.text(resource)
			end.join(", ")
		end
		
		map(Date) do |object, **options|
			object.strftime
		end
		
		map(DateTime) do |object, **options|
			object.strftime("%c %Z")
		end
		
		map(BigDecimal) do |object, **options|
			object.to_s("F")
		end
		
		def quantity(transaction)
			if transaction.unit?
				"#{transaction.quantity.to_s('F')} #{transaction.unit}"
			else
				transaction.quantity.to_s("F")
			end
		end

		def hours(duration)
			hours = duration.floor
			minutes = ((duration - hours) * 60).floor
			
			if hours != 0
				if minutes != 0
					"#{hours}h#{minutes}m"
				else
					"#{hours}h"
				end
			elsif minutes != 0
				"#{minutes}m"
			else
				""
			end
		end

		def tax(object)
			if tax_rate = object.tax_rate
				(object.tax_rate * 100.to_d).to_s("F") + "%"
			end
		end
	end
end
