
require 'financier'

RSpec.describe Financier::Billing do
	let(:today) {Date.today}
	let(:period) {Periodical::Period.load("1 months")}
	
	before(:each) {Financier::DB.clear!}
	
	let!(:customer) do
		Financier::DB.commit(message: "Test Customer") do |dataset|
			Financier::Customer.insert(dataset, name: "Bob Marly")
		end
	end
	
	let!(:billing) do
		Financier::DB.commit(message: "Initial Billing") do |dataset|
			Financier::Billing.insert(dataset,
				active: true,
				customer: customer,
				start_date: today << 1,
				period: period,
				invoice_date: today,
			)
		end
	end
	
	it "should generate the next billing" do
		next_billing = Financier::DB.commit(message: "Generate Next Billing") do |dataset|
			billing.generate_next(dataset)
		end
		
		expect(billing).to be_due
		expect(next_billing).to_not be_due
	end
end
