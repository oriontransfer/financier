# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

prepend Actions

PARAMETERS = {
	name: true,
	number: true,
	taxable: true,
	description: true,
	created_date: true,
	invoiced_date: true,
	due_date: true,
	customer: true,
	billing_address: true,
	shipping_address: true,
	company: true,
	account: true,
	company_address: true,
}

on "delete" do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params[:rows].values
	
	Financier::DB.commit(message: "Delete Companies") do |dataset|
		documents.each do |document|
			company = Financier::Invoice.fetch_all(dataset, id: document["id"])
			company.delete(dataset)
		end
	end
	
	succeed!
end

on "new" do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current, :created_date => Date.today)
	
	if request.post?
		@invoice.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Create Invoice") do |dataset|
			@invoice.save(dataset)
		end
		
		redirect! "index"
	end
end

on "edit" do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request.params[:id])
	
	if request.post?
		@invoice.assign(request.params, PARAMETERS)
		@invoice.updated_date = Date.today
		
		Financier::DB.commit(message: "Edit Invoice") do |dataset|
			@invoice.save(dataset)
		end
		
		redirect! request.params[:_return] || "index"
	end
end

on "show" do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request.params[:id])
end
