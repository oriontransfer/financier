# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require_relative "database"

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
			Address.by_principal(@dataset, principal: self)
		end
		
		def accounts
			Account.by_company(@dataset, company: self)
		end
		
		view :all, :type, index: :id
	end
end
