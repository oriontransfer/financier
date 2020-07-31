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

require 'periodical/period'

module Financier
	class Customer; end
	class Address; end
	class Invoice; end
	
	class Billing
		include Relaxo::Model
		
		property :id, UUID
		
		# Whether this billing will continue to function:
		property :active, Attribute[Boolean]
		
		property :customer, BelongsTo[Customer]
		property :address, Optional[BelongsTo[Address]]
		
		# The start date of the billing cycle:
		property :start_date, Attribute[Date]

		# The period of the billing cycle:
		property :period, Serialized[Periodical::Period]
		
		# The date on which to send the invoice:
		property :invoice_date, Attribute[Date]
		
		property :invoice, Optional[BelongsTo[Invoice]]
		
		# The date the invoice was sent:
		property :sent_at, Attribute[DateTime]
		
		# The previous and next billing cycles:
		property :next_billing, Optional[BelongsTo[Billing]]
		property :previous_billing, Optional[BelongsTo[Billing]]
		
		def end_date
			self.period.advance(self.start_date)
		end
		
		def due?(date = Date.today)
			self.invoice_date <= date
		end
		
		def generate_invoice(dataset)
			self.invoice = Invoice.create(dataset)
			
			self.relevant_services.each do |service|
				service.assign_to_invoice(self.invoice)
			end
			
			self.relevant_timesheet_entries.each do |entry|
				entry.assign_to_invoice(self.invoice)
			end
			
			return self.invoice
		end
		
		# Generate the next billing cycle and update the current one.
		def generate_next(dataset)
			raise ArgumentError.new("Record must be persisted") unless self.persisted?
			raise ArgumentError.new("Already has next billing") if self.next_billing?
			raise ArgumentError.new("This billing is not active") unless self.active?
			
			# Set up linked list structure:
			self.next_billing = self.dup.tap do |billing|
				billing.clear(:id)
				
				billing.previous_billing = self
				billing.start_date = self.end_date
				billing.invoice_date = self.period.advance(self.invoice_date)
			end
			
			self.next_billing.save(dataset)
			self.save(dataset)
			
			return self.next_billing
		end
		
		view :all, :type, index: :id
	end
end
