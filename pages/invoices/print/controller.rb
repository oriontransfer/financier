
prepend Actions

on 'full' do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request[:id])
end

on 'plain' do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request[:id])
end

