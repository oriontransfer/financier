
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Users") do |dataset|
		documents.each do |document|
			user = Financier::User.fetch_all(dataset, id: document['id'])
			user.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@user = Financier::User.create(Financier::DB.current)
	
	if request.post?
		@user.assign(request.params)
		
		Financier::DB.commit(message: "New User") do |dataset|
			@user.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@user = Financier::User.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@user.assign(request.params)
		
		Financier::DB.commit(message: "Edit User") do |dataset|
			@user.save(dataset)
		end
		
		redirect! "index"
	end
end
