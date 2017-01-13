
prepend Actions

on 'company' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB, request.params)
end

on 'customer' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB, request.params)
end
