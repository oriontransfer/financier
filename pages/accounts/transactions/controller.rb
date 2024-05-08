
prepend Actions

PARAMETERS = {
	name: true,
	timestamp: true,
	amount: true,
	description: true,
	principal: true,
}

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Account Transactions") do |dataset|
		documents.each do |document|
			transaction = Financier::Account::Transaction.fetch_all(dataset, id: document['id'])
			transaction.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@transaction = Financier::Account::Transaction.create(Financier::DB.current, timestamp: Time.now)
	
	@transaction.account = Financier::Account.fetch_all(@transaction.dataset, id: request[:account_id])
	
	if request.post?
		@transaction.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Account Transaction") do |dataset|
			@transaction.save(dataset)
		end
		
		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end

on 'show' do |request, path|
	@transaction = Financier::Account::Transaction.fetch_all(Financier::DB.current, id: request[:id])
end

on 'edit' do |request, path|
	@transaction = Financier::Account::Transaction.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@transaction.assign(request.params, PARAMETERS)

		Financier::DB.commit(message: "Edit Account Transaction") do |dataset|
			@transaction.save(dataset)
		end
		
		redirect! request[:_return] || "../show?id=#{@transaction.account.id}"
	end
end
