
on 'full' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB, request[:id])
end

on 'plain' do |request, path|
	@invoice = Financier::Invoice.fetch(Financier::DB, request[:id])
end

