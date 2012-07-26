
require 'json'

def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.session do |session|
			service = Financier::Service::fetch(session, document['id'])
			
			if service.rev == document['rev']
				service.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	service = request.controller[:service] = Financier::Service.create(Financier::DB, :start_date => Date.today, :period => 7)
	
	if request.post?
		service.assign(request.params)
		
		service.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	service = request.controller[:service] = Financier::Service.fetch(Financier::DB, request[:id])
	
	if request.post?
		service.assign(request.params)
		
		service.save
		
		redirect! "index"
	end
end

def on_invoice(path, request)
	ids = request[:ids]
	services = ids.map{|id| Financier::Service.fetch(Financier::DB, id)}
	
	request.controller[:services] = services
	billing_end_date = request.controller[:billing_end_date] = Date.parse(request[:billing_end_date]) rescue Date.today
	
	if request[:billing_customer]
		billing_customer = request.controller[:billing_customer] = Financier::Customer.fetch(Financier::DB, request[:billing_customer])
	else
		billing_customer = request.controller[:billing_customer] = services.first.customer
	end
	
	if request.post? && request[:create]
		invoice = nil
		
		Financier::DB.session do |session|
			invoice = Financier::Invoice.create_invoice_for_services(session, services, billing_end_date)
			
			invoice.customer = billing_customer
			
			invoice.save
		end
	
		redirect! "../invoices/show?id=#{invoice.id}"
	end
end

