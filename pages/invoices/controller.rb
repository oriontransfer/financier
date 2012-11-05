
include Direct

def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			invoice = Financier::Invoice::fetch(db, document['id'])
			
			if invoice.rev == document['rev']
				invoice.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	@invoice = Financier::Invoice.create(Financier::DB, :created_date => Date.today)
	
	if request.post?
		@invoice.assign(request.params)
		
		@invoice.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	@invoice = Financier::Invoice.fetch(Financier::DB, request[:id])
	
	if request.post?
		@invoice.assign(request.params)
		@invoice.updated_date = Date.today
		@invoice.save
		
		redirect! request[:_return] || "index"
	end
end

def on_show(path, request)
	request.controller[:invoice] = Financier::Invoice.fetch(Financier::DB, request[:id])
end

def on_print(path, request)
	request.controller[:invoice] = Financier::Invoice.fetch(Financier::DB, request[:id])
end
