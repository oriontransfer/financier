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

require_relative 'database'
require 'periodical'

module Financier
	class Customer; end
	class Service; end
	
	class Service
		include Relaxo::Model
		
		property :id, UUID
		
		property :name
		property :description

		property :domain
		property :active, Attribute[Boolean]

		property :start_date, Attribute[Date]
		property :billed_until_date, Optional[Attribute[Date]]
		property :customer, BelongsTo[Customer]

		property :periodic_cost, Attribute[Latinum::Resource]
		property :period, Serialized[Periodical::Period]

		# An array of dates where billing has occurred
		property :billed_dates, ArrayOf[Date]

		view :all, :type, index: :id
		view :by_customer, index: unique(:start_date, :id)
		
		def after_fetch
			# Fix up old data:
			if @attributes['end_date']
				@attributes['billed_until_date'] = @attributes.delete('end_date')
			end
		end
		
		def after_create
			self.start_date ||= Date.today
			self.billed_until_date ||= self.start_date
			self.billed_dates ||= []
		end
		
		def periods_to_date(date)
			(Periodical::Duration.new(self.billed_until_date, date) / self.period).ceil
		end
		
		# As we charge whole units, e.g. one whole year, given a date which means that something should be billed, compute the date which the paid amount covers. i.e. if billing monthly on the 1st, and date is the 20th, this would give the first of the next month.
		def next_billed_date(date)
			# We bill partial periods in advance if possible:
			count = self.periods_to_date(date)
			
			# Calculate the date of the last period billed:
			self.period.advance(self.billed_until_date, count)
		end
		
		def bill_until_date(date)
			self.billed_until_date = self.next_billed_date(date)
			self.billed_dates << date
		end
		
		def billing_description(to_date = nil)
			if to_date
				"From #{self.billed_until_date} to #{self.next_billed_date(to_date)} for #{self.domain}. #{self.description}"
			else
				"From #{self.billed_until_date} for #{self.domain}. #{self.description}"
			end.strip
		end
		
		def self.generate_invoice(dataset, services, date, **arguments)
			today = Date.today
			
			invoice = Invoice.insert(dataset, **arguments)
			
			services.each do |service|
				# Round down the number of periods:
				periods = service.periods_to_date(date)
				
				$stderr.puts "Periods for service #{service.name}: #{periods.inspect}"
				
				if periods >= 1
					transaction = Invoice::Transaction.create(dataset,
						service: service,
						name: service.name,
						price: service.periodic_cost,
						quantity: periods.to_d,
						date: today,
						description: service.billing_description(date),
						invoice: invoice
					)
					
					transaction.save(dataset)
					service.bill_until_date(date)
					service.save(dataset)
				end
			end
			
			return invoice
		end
	end
end
