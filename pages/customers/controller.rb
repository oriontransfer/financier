
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			customer = Financier::Customer::fetch(db, document['id'])
			
			if customer.rev == document['rev']
				customer.delete
			else
				fail!
			end
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@customer = Financier::Customer.create(Financier::DB.current)
	
	if request.post?
		puts request.params.inspect
		@customer.assign(request.params)
		
		Financier::DB.commit(message: path.to_s) do |dataset|
			@customer.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@customer = Financier::Customer.fetch(Financier::DB.current, request[:id])
	
	if request.post?
		@customer.assign(request.params)
		
		@customer.save
		
		redirect! "index"
	end
end

on 'show' do |request, path|
	@customer = Financier::Customer.fetch_all(Financier::DB.current, id: request[:id])
	
	@transactions = []
	@transactions += @customer.invoices.to_a
	@transactions += @customer.account_transactions.to_a
	@transactions.sort_by! &:date
end
