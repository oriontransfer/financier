
require 'financier/database'

module Financier
	class Company; end
	class Customer; end
	
	class Address
		include Relaxo::Model
		
		property :attention
		property :unit
		property :street
		property :suburb
		property :city
		property :region
		property :postcode
		property :country
		
		property :phone
		property :email
		
		property :purpose
		property :for, Polymorphic[Company, Customer]
		
		property :created_date, Attribute[Date]
		property :updated_date, Attribute[Date]
		property :last_used_date, Optional[Attribute[Date]]
		
		def after_create
			self.created_date = Date.today
		end
		
		def before_save
			self.updated_date = Date.today
		end
		
		view :all, 'financier/address', Address
	end
end
