
include Direct

def on_edit(path, request)
	@transaction = Financier::Account::Transaction.fetch(Financier::DB, request[:id])
	
	if request.post?
		@transaction.assign(request.params)

		@transaction.save

		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end
