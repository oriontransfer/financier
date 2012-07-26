
require 'financier/database'

module Financier
	class Company; end
	class Customer; end
	
	class Address
		include Relaxo::Model
		
		property :attention
		property :unit
		property :street
		property :city
		property :region
		property :postcode
		property :country
	end
	
	class CompanyAddress < Address
		include Relaxo::Model
		
		property :company, Optional[BelongsTo[Company]]
	end
	
	class CustomerAddress < Address
		include Relaxo::Model
		
		property :customer, Optional[BelongsTo[Customer]]
	end
end