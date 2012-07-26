
require 'financier/database'

module Financier
	class CompanyAddress; end
	
	class Company
		include Relaxo::Model
		
		property :name
		
		# One of "primary", "supplier"
		property :role
		
		relationship :addresses, 'financier/invoice_by_customer', CompanyAddress
	end
	
end