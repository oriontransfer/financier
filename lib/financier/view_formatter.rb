# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
		
		map(Latinum::Collection) do |object, options|
			object.map do |resource|
				self.text(resource)
			end.join(", ")
		end
		
		map(Date) do |object, options|
			object.strftime
		end
		
		map(DateTime) do |object, options|
			object.strftime("%c %Z")
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
			(object.tax_rate * 100.to_d).to_s('F') + '%'
		end
	end
end
