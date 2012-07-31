
require 'financier/database'

module Financier
	class Service; end
	class Invoice; end
	class Address; end
	
	class Customer
		include Relaxo::Model
		
		property :name
		property :email_address
		
		view :all, 'financier/customer', Customer
		view :by_name, 'financier/customer_by_name', Customer
		relationship :services, 'financier/service_by_customer', Service
		
		relationship :invoices, 'financier/invoice_by_customer', Invoice
		relationship :invoice_count, 'financier/invoice_count_by_customer', ValueOf, :reduction => :first, :key => :self
		
		relationship :account_transactions, 'financier/account_transaction_by_customer', Account::Transaction
		
		relationship :addresses, 'financier/address_by_customer', Address
	end
	
end
