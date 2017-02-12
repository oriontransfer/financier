
prepend Actions

on 'company' do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current)
	@invoice.assign(request.params)
end

on 'customer' do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current)
	@invoice.assign(request.params)
end
