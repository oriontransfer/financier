
prepend Actions

PARAMETERS = {
	attention: true,
	unit: true,
	street: true,
	suburb: true,
	city: true,
	region: true,
	postcode: true,
	country: true,
	phone: true,
	email: true,
	purpose: true,
}

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Companies") do |dataset|
		documents.each do |document|
			address = Financier::Address.fetch_all(dataset, id: document['id'])
			address.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@address = Financier::Address.create(Financier::DB.current)
	
	if request.post?
		@address.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Address") do |dataset|
			@address.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@address = Financier::Address.fetch_all(Financier::DB.current, id: request[:id])

	if request.post?
		@address.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Address") do |dataset|
			@address.save(dataset)
		end
	end
	
	redirect! "index" if request.post?
end

on 'print' do |request, path|
	@address = Financier::Address.fetch_all(Financier::DB.current, id: request[:id])
end
