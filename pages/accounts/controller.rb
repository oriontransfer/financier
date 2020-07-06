
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Companies") do |dataset|
		documents.each do |document|
			account = Financier::Account.fetch_all(dataset, id: document['id'])
			account.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@account = Financier::Account.create(Financier::DB.current)
	
	if request.post?
		@account.assign(request.params)
		
		Financier::DB.commit(message: "New Account") do |dataset|
			@account.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@account = Financier::Account.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@account.assign(request.params)
		
		Financier::DB.commit(message: "Edit Account") do |dataset|
			@account.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'show' do |request, path|
	@account = Financier::Account.fetch_all(Financier::DB.current, id: request[:id])
end

on 'download' do |request, path|
	@account = Financier::Account.fetch_all(Financier::DB.current, id: request[:id])
	
	currencies = Set.new
	balance = Latinum::Collection.new(currencies)
	
	buffer = StringIO.new
	csv = CSV.new(buffer)
	
	csv << ["date", "reference", "amount", "currency", "principal"]
	
	@account.transactions.sort_by(&:timestamp).each do |transaction|
		csv << [transaction.timestamp, transaction.name, transaction.amount.to_s('F'), transaction.amount.name, transaction.principal&.name]
	end
	
	succeed! content: buffer.string
end

def import_ofx(path)
	Financier::DB.commit(message: "Import OFX Transactions") do |dataset|
		OFX(path) do |parser|
			#puts YAML::dump(parser.account)
			#puts YAML::dump(parser.account.balance)
			#puts YAML::dump(parser.account.transactions)
			account = parser.account
		
			account.transactions.each do |record|
				puts YAML::dump(record)
			
				transaction = Financier::Account::Transaction.create(dataset)
				transaction.amount = Latinum::Resource.new(record.amount, account.currency)
				transaction.name = record.memo
				transaction.timestamp = record.posted_at
				transaction.account = @account
			
				transaction.save(dataset)
			end
		end
	end
end

def import_qif(path)
	qif = Qif::Reader.new(open(path))
	
	Financier::DB.commit(message: "Import QIF Transactions") do |dataset|
		qif.each do |record|
			transaction = Financier::Account::Transaction.create(dataset)
			transaction.amount = Latinum::Resource.new(record.amount, @default_currency)
			transaction.name = record.memo
			transaction.timestamp = record.date.to_datetime
			transaction.account = @account
		
			transaction.save(dataset)
		end
	end
end

def import_csv(path)
	Financier::DB.commit(message: "Import CSV Transactions") do |dataset|
		CSV.foreach(path, :headers => true, :header_converters => :symbol, :converters => [:blank_to_nil]) do |row|
			transaction = Financier::Account::Transaction.create(dataset)
			
			currency = row[:currency] || @default_currency
			
			if credit = row[:credit]
				credit.gsub!(',', '') if credit.is_a? String
				transaction.amount = Latinum::Resource.new(credit, currency)
			elsif debit = row[:debit]
				debit.gsub!(',', '') if debit.is_a? String
				transaction.amount = -Latinum::Resource.new(debit, currency)
			end
			
			transaction.name = row[:reference]
			transaction.timestamp = Date.parse(row[:date])
			transaction.account = @account
		
			transaction.save(dataset)
		end
	end
end

on 'import' do |request, path|
	if request[:account]
		@account = Financier::Account.fetch(Financier::DB.current, request[:account])
	else
		@account = nil
	end
	
	@default_currency = request[:default_currency] || "NZD"
	
	if request.post? and @account
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
