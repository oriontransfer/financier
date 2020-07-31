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

module Financier
	class Service; end
	class Invoice; end
	class Address; end
	
	class Customer
		include Relaxo::Model
		
		property :id, UUID
		
		property :name
		property :email_address
		
		view :all, :type, index: :id
		view :by_name, :type, 'by_name', index: unique(:name)
		
		def invoices
			Invoice.by_customer(@dataset, customer: self)
		end
		
		def account_transactions
			Account::Transaction.by_principal(@dataset, principal: self)
		end
		
		def addresses
			Address::by_principal(@dataset, principal: self)
		end
		
		def services
			Service::by_customer(@dataset, customer: self)
		end
		
		def balance
			sum = Latinum::Collection.new
			
			invoices.each{|invoice| sum << -invoice.totals unless invoice.quotation?}
			account_transactions.each{|transaction| sum << transaction.amount}
			
			return sum.compact
		end
		
		# relationship :services, 'financier/service_by_customer', Service
		# 
		# relationship :invoices, 'financier/invoice_by_customer', Invoice
		# relationship :invoice_count, 'financier/invoice_count_by_customer', ValueOf, :reduction => :first, :key => :self
		# 
		# relationship :account_transactions, 'financier/account_transaction_by_customer', Account::Transaction
		# 
		# relationship :addresses, 'financier/address_by_customer', Address
	end
end
