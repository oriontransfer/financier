# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

prepend Actions

PARAMETERS = {
	name: true,
	description: true,
	date: true,
	
	price: true,
	quantity: true,
	unit: true,
	
	tax_code: true,
	tax_rate: true,
	
	exchange_rate: true,
	exchange_name: true,
}

on "delete" do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params["rows"].values
	
	Financier::DB.commit(message: "Delete Invoice Transactions") do |dataset|
		documents.each do |document|
			company = Financier::Invoice::Transaction.fetch_all(dataset, id: document["id"])
			company.delete(dataset)
		end
	end
	
	succeed!
end

on "new" do |request, path|
	@transaction = Financier::Invoice::Transaction.create(Financier::DB.current, :date => Date.today, :quantity => 1)
	
	@transaction.invoice = Financier::Invoice.fetch_all(@transaction.dataset, id: request.params["invoice_id"])
	
	if request.post?
		@transaction.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Invoice Transaction") do |dataset|
			@transaction.save(dataset)
		end
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end

on "edit" do |request, path|
	@transaction = Financier::Invoice::Transaction.fetch_all(Financier::DB.current, id: request.params["id"])
	
	if request.post?
		@transaction.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Invoice Transaction") do |dataset|
			@transaction.save(dataset)
		end
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end

on "move" do |request, path|
	@transaction = Financier::Invoice::Transaction.fetch_all(Financier::DB.current, id: request.params["id"])
	
	if request.post?
		@transaction.assign(request.params)
		
		Financier::DB.commit(message: "Move Invoice Transaction") do |dataset|
			@transaction.save(dataset)
		end
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end
