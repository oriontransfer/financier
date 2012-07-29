
require 'financier/database'

module Financier
	class Address; end
	class Account; end
	
	class Company
		include Relaxo::Model
		
		property :name
		
		# One of "primary", "supplier"
		property :role
		
		relationship :addresses, 'financier/address_by_company', Address
		relationship :accounts, 'financier/account_by_company', Account

		view :all, 'financier/company', Company
	end
	
end