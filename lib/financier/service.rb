
require 'financier/database'
require 'periodical'

module Financier
	class Customer; end
	class Service; end
	
	class Service
		include Relaxo::Model
		
		property :name
		property :description

		property :domain
		property :active, Attribute[Boolean]

		property :start_date, Attribute[Date]
		property :billed_until_date, Optional[Attribute[Date]]
		property :customer, BelongsTo[Customer]

		property :periodic_cost, Attribute[Latinum::Resource]
		property :period, Serialized[Periodical::Period]

		# An array of dates where billing has occurred
		property :billed_dates, ArrayOf[Date]

		view :all, 'financier/service', Service
		view :by_customer, 'financier/service_by_customer', Service
		
		def initialize(database, attributes)
			super database, attributes
			
			if @attributes['end_date']
				@attributes['billed_until_date'] = @attributes.delete('end_date')
			end
			
			self.billed_until_date ||= self.start_date
			self.billed_dates ||= []
		end
		
		def after_create
			self.start_date ||= Date.today
		end
		
		def periods_to_date(date)
			(Periodical::Duration.new(self.billed_until_date, date) / self.period).ceil
		end
		
		# As we charge whole units, e.g. one whole year, given a date which means that something should be billed, compute the date which the paid amount covers. i.e. if billing monthly on the 1st, and date is the 20th, this would give the first of the next month.
		def next_billed_date(date)
			# We bill partial periods in advance if possible:
			count = self.periods_to_date(date)
			
			# Calculate the date of the last period billed:
			self.period.advance(self.billed_until_date, count)
		end
		
		def bill_until_date(date)
			self.billed_until_date = self.next_billed_date(date)
			self.billed_dates << date
		end
		
		def billing_description(to_date = nil)
			if to_date
				"From #{self.billed_until_date} to #{self.next_billed_date(to_date)} for #{self.domain}. #{self.description}"
			else
				"From #{self.billed_until_date} for #{self.domain}. #{self.description}"
			end.strip
		end
	end
end
