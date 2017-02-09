
prepend Actions

on 'new' do |request, path|
	@transaction = Financier::Account::Transaction.create(Financier::DB.current, timestamp: Time.now)
	@transaction.assign(account: request[:account_id])
	
	if request.post?
		@transaction.assign(request.params)
		
		@transaction.save
		
		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end

on 'edit' do |request, path|
	@transaction = Financier::Account::Transaction.fetch(Financier::DB.current, request[:id])
	
	if request.post?
		@transaction.assign(request.params)

		@transaction.save

		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end
