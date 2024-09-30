# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

prepend Actions

def timesheet_statistics(dataset)
	data = Financier::Timesheet.statistics(dataset, @today << 12, @today)
	
	current = @calendar.start_month
	labels = []
	series = []
	
	begin
		labels << current.strftime("%d %B")
		series << data[:duration][current]
		
		current = current.next_month
	end while @calendar.include?(current)
	
	return {
		labels: labels,
		series: [
			series
		]
	}
end

on "index" do
	@today = Date.today
	@calendar = Financier::Calendar.new(@today << 12, @today)
	
	dataset = Financier::DB.current
	
	@statistics = {
		timesheet: timesheet_statistics(dataset)
	}
end
