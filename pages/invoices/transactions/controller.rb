
include Utopia::Controller::Direct

def on_new(path, request)
	transaction = request.controller[:transaction] = Financier::Invoice::Transaction.create(Financier::DB, :date => Date.today, :quantity => 1)
	transaction.assign(:invoice => request[:invoice_id])
	
	if request.post?
		transaction.assign(request.params)
		puts "invoice: " + transaction.invoice.inspect
		
		transaction.save
		
		redirect! "../show?id=#{transaction.invoice.id}"
	end
end

def on_edit(path, request)
	transaction = request.controller[:transaction] = Financier::Invoice::Transaction.fetch(Financier::DB, request[:id])
	
	if request.post?
		transaction.assign(request.params)
		
		errors = transaction.save
		puts errors.inspect
		
		redirect! "../show?id=#{transaction.invoice.id}"
	end
end
