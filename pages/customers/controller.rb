
prepend Actions

PARAMETERS = {
	name: true,
}

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params[:rows].values
	
	Financier::DB.commit(message: "Delete Customers") do |dataset|
		documents.each do |document|
			customer = Financier::Customer.fetch_all(dataset, id: document['id'])
			customer.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@customer = Financier::Customer.create(Financier::DB.current)
	
	if request.post?
		@customer.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Customer") do |dataset|
			@customer.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@customer = Financier::Customer.fetch_all(Financier::DB.current, id: request.params[:id])
	
	if request.post?
		@customer.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Customer") do |dataset|
			@customer.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'show' do |request, path|
	@customer = Financier::Customer.fetch_all(Financier::DB.current, id: request.params[:id])
	
	@transactions = []
	@transactions += @customer.invoices.to_a
	@transactions += @customer.account_transactions.to_a
	@transactions.sort_by! &:date
end
