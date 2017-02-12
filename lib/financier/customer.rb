
require 'financier/database'

module Financier
	class Service; end
	class Invoice; end
	class Address; end
	
	class Customer
		include Relaxo::Model
		
		property :id, UUID
		
		property :name
		property :email_address
		
		view :all, [:type], index: [:id]
		view :by_name, [:type, 'by_name'], index: [:name]
		
		def invoices
			Invoice.by_customer(@dataset, customer: self)
		end
		
		def account_transactions
			Account::Transaction.by_principal(@dataset, principal: self)
		end
		
		def addresses
			Address::by_principal(@dataset, principal: self)
		end
		
		def services
			Service::by_customer(@dataset, customer: self)
		end
		
		# relationship :services, 'financier/service_by_customer', Service
		# 
		# relationship :invoices, 'financier/invoice_by_customer', Invoice
		# relationship :invoice_count, 'financier/invoice_count_by_customer', ValueOf, :reduction => :first, :key => :self
		# 
		# relationship :account_transactions, 'financier/account_transaction_by_customer', Account::Transaction
		# 
		# relationship :addresses, 'financier/address_by_customer', Address
	end
end
