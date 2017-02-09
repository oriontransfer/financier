
require 'financier/database'

module Financier
	class Address; end
	class Account; end
	
	class Company
		include Relaxo::Model
		
		property :id, UUID
		
		property :name
		
		# One of "primary", "supplier"
		property :role
		
		# relationship :addresses, 'financier/address_by_company', Address
		# relationship :accounts, 'financier/account_by_company', Account

		def addresses
			Address.for(@dataset, for: self)
		end
		
		def addresses
			Account.for(@dataset, for: self)
		end
		
		view :all, [:type], index: [:id]
	end
end
