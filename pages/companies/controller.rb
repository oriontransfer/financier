
include Controller::Direct

def on_delete(path, request)
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

def on_new(path, request)
	@company = Financier::Company.create(Financier::DB)
	
	if request.post?
		@company.assign(request.params)
		@company.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	@company = Financier::Company.fetch(Financier::DB, request[:id])
	
	if request.post?
		@company.assign(request.params)
		@company.save
		
		redirect! "index"
	end
end

def on_index(path, request)
	@companies = Financier::Company.all(Financier::DB)
end
