
def on_company(path, request)
	@invoice = Financier::Invoice.fetch(Financier::DB, request[:id])
	
	if request[:company]
		@invoice.company = Financier::Company.fetch(Financier::DB, request[:company])
	end
end

def on_customer(path, request)
	@invoice = Financier::Invoice.fetch(Financier::DB, request[:id])
	
	if request[:customer]
		@invoice.customer = Financier::Customer.fetch(Financier::DB, request[:customer])
	end
end
