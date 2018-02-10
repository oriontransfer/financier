
require 'financier/database'

require_relative 'timesheet'

module Financier
	def self.generate_invoice_number
		today = Date.today
		offset = (Time.now - Time.parse("#{today.year}/1/1")) / 600

		year_code = (today.year - 2012).to_s(36)[0..1].upcase

		"X#{year_code}#{offset.to_i.to_s(16).upcase}"
	end

	class Invoice
		include Relaxo::Model
		
		property :id, UUID
		
		class Transaction
			include Relaxo::Model
			parent_type Invoice
			
			view :all, [:type], index: [:id]
			view :by_invoice, [:type, 'by_invoice', :invoice], index: [[:date, :id]]
			
			property :id, UUID
			
			property :name
			property :description

			property :date, Attribute[Date]
			property :price, Attribute[Latinum::Resource]
			property :quantity, Attribute[BigDecimal]
			property :unit

			property :exchange_rate, Optional[Attribute[BigDecimal]]
			property :exchange_name

			property :invoice, BelongsTo[Invoice]

			# Transactions may be generated automatically by other parts of the system:
			property :service, Optional[BelongsTo[Service]]
			property :timesheet, Optional[BelongsTo[Timesheet]]

			property :tax_code
			property :tax_rate, Attribute[BigDecimal]

			property :total, Attribute[Latinum::Resource]

			def after_create
				self[:tax_rate] ||= DEFAULT_TAX_RATE
			end

			def subtotal
				price * quantity.to_d
			end

			def before_save
				native_total = subtotal * (tax_rate + 1).to_d
				
				if exchange_name && exchange_rate
					# We need to round the exchanged total based on the currency, otherwise over time the account may be a few units out.
					self.total = native_total.exchange(exchange_rate, exchange_name, BANK[exchange_name][:precision])
				else
					self.total = native_total
				end
			end
		end
		
		property :name
		property :number
		property :status
		property :description
		
		def detailed_name
			"#{self.number} - #{title} for #{self.name}"
		end
		
		property :created_date, Attribute[Date]
		property :updated_date, Attribute[Date]
		property :invoiced_date, Optional[Attribute[Date]]
		property :due_date, Optional[Attribute[Date]]
		
		def date
			self.invoiced_date || self.created_date
		end
		
		def quotation?
			not (self.invoiced_date && self.invoiced_date <= Date.today)
		end
		
		def title
			if quotation?
				"Quotation"
			else
				"Tax Invoice"
			end
		end
		
		# The company issuing the invoice:
		property :company, BelongsTo[Company]
		# The address for the company, typically used as a return address:
		property :company_address, Optional[HasOne[Address]]
		# The account that payment should be made to:
		property :account, Optional[BelongsTo[Account]]
		
		# The customer who is being billed:
		property :customer, BelongsTo[Customer]
		# The address where the invoice will be sent:
		property :billing_address, Optional[HasOne[Address]]
		# The address where the items should be shipped:
		property :shipping_address, Optional[HasOne[Address]]
		
		def transactions
			Transaction::by_invoice(@dataset, invoice: self)
		end
		
		def totals
			collection = Latinum::Collection.new
			collection << self.transactions.map(&:total)
			
			return collection
		end
		
		# relationship :totals, 'financier/transaction_total_by_invoice', {:group => true, :startkey => [:self], :endkey => [:self, {}]} do |database, row|
			# Latinum::Resource.new(row['value'], row['key'][1])
		# end
		
		def after_create
			self.number ||= Financier::generate_invoice_number
			self.created_date = Date.today
		end
		
		def update_total
			self.total = self.transactions.inject{|sum,transaction| sum + transaction.total}
		end
		
		def before_delete
			self.transactions.each(&:delete)
		end
		
		view :all, [:type], index: [:id]
		# relationship :transactions, 'financier/transaction_by_invoice', Transaction
		
		view :by_customer, [:type, :customer], index: [[:created_date, :id]]
		# view :count_by_customer, 'financier/invoice_count_by_customer'
	end
end
