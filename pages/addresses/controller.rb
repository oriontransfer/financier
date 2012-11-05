
def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			address = Financier::Address::fetch(db, document['id'])
			
			if address.rev == document['rev']
				address.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	@address = Financier::Address.create(Financier::DB)
	
	if request.post?
		@address.assign(request.params)
		
		@address.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	@address = Financier::Address.fetch(Financier::DB, request[:id])

	if request.post?
		@address.assign(request.params)
		@address.save
	end
	
	redirect! "index" if request.post?
end

def on_print(path, request)
	@address = Financier::Address.fetch(Financier::DB, request[:id])
end
