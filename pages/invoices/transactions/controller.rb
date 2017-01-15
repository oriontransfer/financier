
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			invoice = Financier::Invoice::Transaction::fetch(db, document['id'])
			
			if invoice.rev == document['rev']
				invoice.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

on 'new' do |request, path|
	@transaction = Financier::Invoice::Transaction.create(Financier::DB, :date => Date.today, :quantity => 1)
	@transaction.assign(:invoice => request[:invoice_id])
	
	if request.post?
		@transaction.assign(request.params)
		
		@transaction.save
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end

on 'edit' do |request, path|
	@transaction = Financier::Invoice::Transaction.fetch(Financier::DB, request[:id])
	
	if request.post?
		@transaction.assign(request.params)
		
		@transaction.save
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end

on 'move' do |request, path|
	@transaction = Financier::Invoice::Transaction.fetch(Financier::DB, request[:id])
	
	if request.post?
		@transaction.assign(request.params)
		
		@transaction.save
		
		redirect! "../show?id=#{@transaction.invoice.id}"
	end
end
