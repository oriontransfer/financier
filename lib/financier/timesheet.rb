
require 'financier/database'

require 'bigdecimal/util'
require 'time/zone/timestamp'

module Financier
	class Duration
		HM = /^(\d+h)?(\d+m)?$/
		
		def self.convert_to_primative(value)
			value.to_s('F')
		end

		def self.convert_from_primative(dataset, value)
			if match = HM.match(value)
				total = BigDecimal.new(0)
				
				if string = match[1]
					total += string.to_d
				end
				
				if string = match[2]
					total += string.to_d / 60.0
				end
				
				return total
			else
				value.to_d
			end
		end
	end
	
	class Timesheet
		include Relaxo::Model
		
		view :all, :type, index: :id
		
		property :id, UUID
		property :name
		property :description
		
		property :color
		
		# Hourly rate:
		property :price, Attribute[Latinum::Resource]
		
		property :exchange_rate, Optional[Attribute[BigDecimal]]
		property :exchange_name
		
		property :tax_code
		property :tax_rate, Attribute[BigDecimal]
		
		class Entry
			include Relaxo::Model
			
			parent_type Timesheet
			
			property :id, UUID
			property :name
			property :description
			
			view :all, :type, index: :id
			view :by_timesheet, index: unique(:finished_at, :id)
			
			# The number of hours worked.
			property :duration, Duration
			
			# The date the job was done:
			property :finished_at, Serialized[Time::Zone::Timestamp]
			
			# The invoice that this entry is assigned to:
			property :timesheet, BelongsTo[Timesheet]
			
			# The invoice that this entry is assigned to:
			property :invoice, Optional[BelongsTo[Invoice]]
			
			# The date that this entry would be shown on a calendar:
			def date
				# Duration is measured in hours
				seconds = duration*60*60
				
				return (finished_at - seconds).to_date
			end
			
			def subtotal
				self.timesheet.price * self.duration
			end
		end
		
		def entries
			Entry::by_timesheet(@dataset, timesheet: self)
		end
		
		def self.generate_invoice(dataset, entries, **arguments)
			invoice = Invoice.insert(dataset, **arguments)
			
			entries.each do |entry|
				transaction = Invoice::Transaction.create(dataset,
					name: "#{entry.name} (#{entry.timesheet.name})",
					description: entry.description,
					price: entry.timesheet.price,
					quantity: entry.duration,
					tax_code: entry.timesheet.tax_code,
					tax_rate: entry.timesheet.tax_rate,
					exchange_rate: entry.timesheet.exchange_rate,
					exchange_name: entry.timesheet.exchange_name,
					unit: "hour(s)",
					date: entry.date,
					timesheet: entry.timesheet,
					invoice: invoice
				)
				
				transaction.save(dataset)
				entry.invoice = invoice
				entry.save(dataset)
			end
			
			return invoice
		end
		
		def self.key(date)
			Date.new(date.year, date.month, 1)
		end
		
		def self.statistics(dataset, start_date, end_date)
			duration = {}
			
			Entry.all(dataset).each do |entry|
				key = self.key(entry.date)
				
				duration[key] ||= 0
				duration[key] += entry.duration
			end
			
			return {
				duration: duration
			}
		end
	end
end
