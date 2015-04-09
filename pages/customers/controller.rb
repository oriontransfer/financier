
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
	
	respond! 200
end

on 'new' do |request, path|
	@customer = Financier::Customer.create(Financier::DB)
	
	if request.post?
		@customer.assign(request.params)
		
		@customer.save
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@customer = Financier::Customer.fetch(Financier::DB, request[:id])
	
	if request.post?
		@customer.assign(request.params)
		
		@customer.save
		
		redirect! "index"
	end
end

on 'show' do |request, path|
	@customer = Financier::Customer.fetch(Financier::DB, request[:id])
	
	@transactions = []
	@transactions += @customer.invoices.to_a
	@transactions += @customer.account_transactions.to_a
	@transactions.sort_by! &:date
end
