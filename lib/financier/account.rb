# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require "financier/database"

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
			
			return name.join(", ")
		end
	end
end
