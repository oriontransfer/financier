
def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.session do |session|
			customer = Financier::Customer::fetch(session, document['id'])
			
			if customer.rev == document['rev']
				customer.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	@customer = Financier::Customer.create(Financier::DB)
	
	if request.post?
		@customer.assign(request.params)
		
		@customer.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	@customer = Financier::Customer.fetch(Financier::DB, request[:id])
	
	if request.post?
		@customer.assign(request.params)
		
		@customer.save
		
		redirect! "index"
	end
end

def on_show(path, request)
	@customer = Financier::Customer.fetch(Financier::DB, request[:id])
	
	@transactions = []
	@transactions += @customer.invoices.to_a
	@transactions += @customer.account_transactions.to_a
	@transactions.sort_by! &:date
end
