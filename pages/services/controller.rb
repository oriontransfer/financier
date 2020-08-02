
prepend Actions

PARAMETERS = {
	name: true,
	description: true,
	domain: true,
	active: true,
	start_date: true,
	billed_until_date: true,
	customer: true,
	periodic_cost: true,
	period: true,
}

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Services") do |dataset|
		documents.each do |document|
			service = Financier::Service.fetch_all(dataset, id: document['id'])
			service.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@service = Financier::Service.create(Financier::DB.current, :start_date => Date.today, :period => 7)
	
	if request.post?
		@service.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Service") do |dataset|
			@service.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@service = Financier::Service.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@service.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Service") do |dataset|
			@service.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'invoice' do |request, path|
	@services = request[:services].map{|id| Financier::Service.fetch(Financier::DB.current, id)}
	
	@billing_end_date = Date.parse(request[:billing_end_date]) rescue Date.today
	
	if billing_customer = request[:billing_customer]
		@billing_customer = Financier::Customer.fetch(Financier::DB.current, billing_customer)
	else
		@billing_customer = @services.first.customer
	end
	
	if request.post? && request[:create]
		invoice = nil
		
		Financier::DB.commit(message: "Create Invoice for Services") do |dataset|
			invoice = Financier::Service.generate_invoice(dataset, @services, @billing_end_date,
				:name => "Services",
				:customer => @billing_customer
			)
		end
		
		redirect! "../invoices/show?id=#{invoice.id}"
	end
end

