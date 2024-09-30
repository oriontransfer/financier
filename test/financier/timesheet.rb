# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

require "financier"

describe Financier::Billing do
	let(:today) {Date.today}
	
	before do
		Financier::DB.clear!
	end
	
	let(:timesheet) do
		Financier::DB.commit(message: "Test Timesheet") do |dataset|
			Financier::Timesheet.insert(dataset,
				name: "Life",
				price: Latinum::Resource.parse("50 NZD"),
				tax_rate: BigDecimal("0.15")
			)
		end
	end
	
	let(:entry) do
		Financier::DB.commit(message: "Test Timesheet Entry") do |dataset|
			Financier::Timesheet::Entry.insert(dataset,
				timesheet: timesheet,
				duration: BigDecimal(2),
				finished_at: Time::Zone::Timestamp.new(2018, 4, 2, 17, 0, 0, "Pacific/Auckland"),
			)
		end
	end
	
	it "can generate invoice" do
		self.timesheet
		self.entry
		
		Financier::DB.commit(message: "Timesheet Invoice") do |dataset|
			local_timesheet = timesheet.dup(dataset)
			expect(local_timesheet.entries).not.to be(:empty?)
			
			invoice = Financier::Timesheet.generate_invoice(
				dataset, local_timesheet.entries
			)
			
			expect(invoice.totals["NZD"]).to be == Latinum::Resource.parse("115 NZD")
		end
	end
end
