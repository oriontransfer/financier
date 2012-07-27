
include Direct

def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.session do |session|
			account = Financier::Customer::fetch(session, document['id'])
			
			if account.rev == document['rev']
				account.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	account = request.controller[:account] = Financier::Account.create(Financier::DB)
	
	if request.post?
		account.assign(request.params)
		
		account.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	account = request.controller[:account] = Financier::Account.fetch(Financier::DB, request[:id])
	
	if request.post?
		account.assign(request.params)
		
		account.save
		
		redirect! "index"
	end
end
