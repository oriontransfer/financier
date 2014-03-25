
include Direct

def on_new(path, request)
	@transaction = Financier::Account::Transaction.create(Financier::DB, timestamp: Time.now)
	@transaction.assign(account: request[:account_id])
	
	if request.post?
		@transaction.assign(request.params)
		
		@transaction.save
		
		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end

def on_edit(path, request)
	@transaction = Financier::Account::Transaction.fetch(Financier::DB, request[:id])
	
	if request.post?
		@transaction.assign(request.params)

		@transaction.save

		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end
