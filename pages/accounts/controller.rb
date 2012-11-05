
include Direct

def on_delete(path, request)
	fail!(:forbidden) unless request.post?
	
	documents = request[:documents].values
	
	documents.each do |document|
		Financier::DB.transaction do |db|
			account = Financier::Account::fetch(db, document['id'])
			
			if account.rev == document['rev']
				account.delete
			else
				fail!
			end
		end
	end
	
	respond! 200
end

def on_new(path, request)
	@account = Financier::Account.create(Financier::DB)
	
	if request.post?
		@account.assign(request.params)
		
		@account.save
		
		redirect! "index"
	end
end

def on_edit(path, request)
	@account = Financier::Account.fetch(Financier::DB, request[:id])
	
	if request.post?
		@account.assign(request.params)
		
		@account.save
		
		redirect! "index"
	end
end

def on_show(path, request)
	@account = Financier::Account.fetch(Financier::DB, request[:id])
end

def import_ofx(path)
	Financier::DB.transaction do |db|
		OFX(path) do |parser|
			#puts YAML::dump(parser.account)
			#puts YAML::dump(parser.account.balance)
			#puts YAML::dump(parser.account.transactions)
			account = parser.account
		
			parser.account.transactions.each do |record|
				puts YAML::dump(record)
			
				transaction = Financier::Account::Transaction.create(db)
				transaction.amount = Latinum::Resource.new(record.amount, account.currency)
				transaction.name = record.memo
				transaction.timestamp = record.posted_at
				transaction.account = @account
			
				transaction.save
			end
		end
	end
end

def import_qif(path)
	qif = Qif::Reader.new(open(path))
	
	Financier::DB.transaction do |db|
		qif.each do |record|
			transaction = Financier::Account::Transaction.create(db)
			transaction.amount = Latinum::Resource.new(record.amount, @default_currency)
			transaction.name = record.memo
			transaction.timestamp = record.date.to_datetime
			transaction.account = @account
		
			transaction.save
		end
	end
end

def on_import(path, request)
	if request[:account]
		@account = Financier::Account.fetch(Financier::DB, request[:account])
	else
		@account = nil
	end
	
	@default_currency = request[:default_currency] || "NZD"
	
	if request.post? && @account
		upload = request[:data]
		
		case upload[:filename]
		when /\.ofx/i
			import_ofx(upload[:tempfile])
		when /\.qif/i
			import_qif(upload[:tempfile])
		end
		
		redirect! "show?id=#{@account.id}"
	end
end