
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Companies") do |dataset|
		documents.each do |document|
			company = Financier::Invoice.fetch_all(dataset, id: document['id'])
			company.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current, :created_date => Date.today)
	
	if request.post?
		@invoice.assign(request.params)
		
		Financier::DB.commit(message: "Create Invoice") do |dataset|
			@invoice.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@invoice.assign(request.params)
		@invoice.updated_date = Date.today
		
		Financier::DB.commit(message: "Edit Invoice") do |dataset|
			@invoice.save(dataset)
		end
		
		redirect! request[:_return] || "index"
	end
end

on 'show' do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request[:id])
end
