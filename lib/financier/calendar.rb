# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

require "date"

module Financier
	class Calendar
		class Week
			def initialize(start_date)
				@start_date = start_date
			end
			
			def each
				return to_enum unless block_given?
				
				7.times do |day|
					yield @start_date + day
				end
			end
		end
		
		def initialize(start_date, end_date, first_weekday: 0)
			@start_date = start_date
			@end_date = end_date
			@first_weekday = first_weekday
		end
		
		attr :start_date
		attr :end_date
		
		def start_year
			@start_date - @start_date.yday + 1
		end
		
		def start_month
			@start_date - @start_date.day + 1
		end
		
		def start_week
			@start_date - @start_date.wday + @first_weekday
		end
		
		def header(&block)
			Week.new(start_week).each(&block)
		end
		
		def include? date
			date >= @start_date and date < @end_date
		end
		
		def each
			return to_enum unless block_given?
			
			current = start_week
			
			begin
				yield Week.new(current)
				current = current + 7
			end while self.include? current
		end
		
		def duration
			@end_date - @start_date
		end
		
		# A list of relative dates (e.g. backwards and forwards)
		def self.today(date = Date.today)
			# Get the 1st of the month:
			month = date - (date.day + 1)
			
			return Calendar.new(month, month.next_month)
		end
		
		def previous
			Calendar.new(@start_date - self.duration, @start_date)
		end
		
		def next
			Calendar.new(@end_date, @end_date + self.duration)
		end
		
		def to_hash
			{start_date: @start_date, end_date: @end_date}
		end
	end
end
