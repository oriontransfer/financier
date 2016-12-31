
prepend Actions

on 'delete' do |request, path|
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

on 'new' do |request, path|
	@account = Financier::Account.create(Financier::DB)
	
	if request.post?
		@account.assign(request.params)
		
		@account.save
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@account = Financier::Account.fetch(Financier::DB, request[:id])
	
	if request.post?
		@account.assign(request.params)
		
		@account.save
		
		redirect! "index"
	end
end

on 'show' do |request, path|
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

def import_csv(path)
	Financier::DB.transaction do |db|
		CSV.foreach(path, :headers => true, :header_converters => :symbol, :converters => [:blank_to_nil]) do |row|
			transaction = Financier::Account::Transaction.create(db)
			
			currency = row[:currency] || @default_currency
			
			if credit = row[:credit]
				transaction.amount = Latinum::Resource.new(credit, currency)
			elsif debit = row[:debit]
				transaction.amount = -Latinum::Resource.new(debit, currency)
			end
			
			transaction.name = row[:reference]
			transaction.timestamp = Date.parse(row[:date])
			transaction.account = @account
		
			transaction.save
		end
	end
end

on 'import' do |request, path|
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
		when /\.csv/i
			import_csv(upload[:tempfile])
		end
		
		redirect! "show?id=#{@account.id}"
	end
end
