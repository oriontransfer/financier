
prepend Actions

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
