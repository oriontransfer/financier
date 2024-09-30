# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require_relative "database"

module Financier
	class Company; end
	class Customer; end
	
	class Address
		include Relaxo::Model
		
		property :id, UUID
		
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
		property :principal, Polymorphic[Company, Customer]
		
		property :created_date, Attribute[Date]
		property :updated_date, Attribute[Date]
		property :last_used_date, Optional[Attribute[Date]]
		
		def after_create
			self.created_date = Date.today
		end
		
		def before_save(changeset)
			self.updated_date = Date.today
		end
		
		# relationship :addresses, 'financier/address_by_company', Address
		
		view :all, :type, index: :id
		view :by_principal, index: unique(:attention, :id)
	end
end
