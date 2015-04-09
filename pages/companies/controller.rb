
on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			@company = Financier::Company::fetch(db, document['id'])
			
			if @company.rev == document['rev']
				@company.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

on 'new' do |request, path|
	@company = Financier::Company.create(Financier::DB)
	
	if request.post?
		@company.assign(request.params)
		@company.save
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@company = Financier::Company.fetch(Financier::DB, request[:id])
	
	if request.post?
		@company.assign(request.params)
		@company.save
		
		redirect! "index"
	end
end

on 'index' do |request, path|
	@companies = Financier::Company.all(Financier::DB)
end
