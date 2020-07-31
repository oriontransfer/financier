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

require 'financier/database'

module Financier
	class Customer; end
	class Account; end
	class Company; end
	
	class Account
		include Relaxo::Model
		
		property :id, UUID
		
		class Transaction
			include Relaxo::Model
			parent_type Account
			
			property :id, UUID
			
			property :name
			property :description
			
			property :amount, Attribute[Latinum::Resource]
			property :timestamp, Attribute[DateTime]
			
			def date
				self.timestamp&.to_date
			end
			
			def totals
				[self.amount]
			end
			
			def detailed_name
				"#{self.name} (#{self.account.name})"
			end
			
			property :principal, Optional[BelongsTo[Customer, Company]]
			property :account, BelongsTo[Account]
			
			view :all, :type, index: :id
			
			view :by_account, index: unique(:timestamp, :id)
			view :by_principal, index: unique(:date, :id)
		end
		
		view :all, :type, index: :id
		
		def transactions
			Transaction.by_account(@dataset, account: self)
		end
		
		property :active, Attribute[Boolean]
		
		property :company, Optional[BelongsTo[Company]]
		
		view :by_company, index: :id
		
		property :pseudonym
		property :description
		
		property :name
		property :number
		
		property :bank_name
		property :bank_number
		property :bank_branch
		
		property :sort_code
		property :swift_code
		
		property :tax_number
		
		property :notes
		
		def bank_string
			name = [self.bank_name, self.bank_branch]
			
			name.delete_if{|item| item == nil || item.empty?}
			
			return name.join(', ')
		end
	end
end
