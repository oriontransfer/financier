
require 'financier/database'

module Financier
	class Customer; end
	class Account; end
	class Company; end
	
	class Account
		include Relaxo::Model
		
		class Transaction
			include Relaxo::Model
			
			property :name
			property :description
			
			property :record
			
			property :amount, Attribute[Latinum::Resource]
			property :timestamp, Attribute[DateTime]
			
			property :customer, BelongsTo[Customer]
			property :account, BelongsTo[Account]
		end
		
		view :all, 'financier/account', Account
		relationship :transactions, 'financier/transaction_by_account', Transaction
		
		property :active, Attribute[Boolean]
		
		property :company, Optional[BelongsTo[Company]]
		
		property :pseudonym
		property :description
		
		property :name
		property :number
		
		property :bank_name
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
