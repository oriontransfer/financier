
prepend Actions

on 'full' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB.current, request[:id])
end

on 'plain' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB.current, request[:id])
end

