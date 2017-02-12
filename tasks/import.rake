
require 'json'
require 'irb'

require 'facets/hash/slice'
require 'facets/hash/symbolize_keys'

namespace :import do
	task :load_documents do
		dump_path = ENV['DUMP_PATH']
		
		@documents = JSON.load(File.read(dump_path)).group_by do |document|
			case type = document["type"]
			when "transaction"
				if document["invoice"]
					"invoice/transaction"
				elsif document["account"]
					"account/transaction"
				else
					"transaction?"
				end
			else
				type
			end
		end
	end
	
	task :users => [:load_documents, :environment] do
		Financier::DB.commit(message: "Import Companies") do |dataset|
			@documents["user"].each do |user|
				instance = Financier::User.create(dataset)
				
				instance.assign(user)
				
				instance.save(dataset)
			end
		end
	end
	
	task :companies => [:load_documents, :environment] do
		@companies = {}
		
		keys = Financier::Company.properties.keys
		
		Financier::DB.commit(message: "Import Companies") do |dataset|
			@documents["company"].each do |company|
				attributes = company.symbolize_keys.slice(*keys)
				@companies[company["_id"]] = Financier::Company.insert(dataset, attributes)
			end
		end
	end
	
	task :customers => [:load_documents, :environment] do
		@customers = {}
		
		keys = Financier::Customer.properties.keys
		
		Financier::DB.commit(message: "Import Customers") do |dataset|
			@documents["customer"].each do |customer|
				attributes = customer.symbolize_keys.slice(*keys)
				@customers[customer["_id"]] = Financier::Customer.insert(dataset, attributes)
			end
		end
	end
	
	task :addresses => [:load_documents, :customers, :companies, :environment] do
		@addresses = {}
		
		keys = Financier::Address.properties.keys
		
		Financier::DB.commit(message: "Import Addresses") do |dataset|
			@documents["address"].each do |address|
				attributes = address.symbolize_keys.slice(*keys)
				
				if object = address["for"]
					case object[0]
					when "customer"
						attributes[:principal] = @customers[object[1]]
					when "company"
						attributes[:principal] = @companies[object[1]]
					end
				end
				
				@addresses[address["_id"]] = Financier::Address.insert(dataset, attributes)
			end
		end
	end
	
	task :services => [:load_documents, :customers, :environment] do
		@services = {}
		
		Financier::DB.commit(message: "Import Services") do |dataset|
			@documents["service"].each do |service|
				instance = @services[service["_id"]] = Financier::Service.create(dataset)
				
				if id = service["customer"]
					service["customer"] = @customers[id].to_s
				end
				
				instance.assign(service)
				
				instance.save(dataset)
			end
		end
	end
	
	task :accounts => [:load_documents, :companies, :environment] do
		@accounts = {}
		
		Financier::DB.commit(message: "Import Accounts") do |dataset|
			@documents["account"].each do |account|
				instance = @accounts[account["_id"]] = Financier::Account.create(dataset)
				
				if id = account["company"]
					account["company"] = @companies[id].to_s
				end
				
				instance.assign(account)
				
				instance.save(dataset)
			end
			
			@documents["account/transaction"].each do |transaction|
				instance = Financier::Account::Transaction.create(dataset)
				
				if id = transaction["account"]
					transaction["account"] = @accounts[id].to_s
				end
				
				if object = transaction["for"]
					transaction[:principal] = case object[0]
						when "customer"
							 @customers[object[1]].to_s
						when "company"
							@companies[object[1]].to_s
					end
				end
				
				instance.assign(transaction)
				
				instance.save(dataset)
			end
		end
	end
	
	task :invoices => [:load_documents, :companies, :environment] do
		@invoices = {}
		
		Financier::DB.commit(message: "Import Invoices") do |dataset|
			@documents["invoice"].each do |invoice|
				instance = @invoices[invoice["_id"]] = Financier::Invoice.create(dataset)
				
				if id = invoice["customer"]
					invoice["customer"] = @customers[id].to_s
				end
				
				if id = invoice["company"]
					invoice["company"] = @companies[id].to_s
				end
				
				if id = invoice["billing_address"]
					invoice["billing_address"] = @addresses[id].to_s
				end
				
				if id = invoice["shipping_address"]
					invoice["shipping_address"] = @addresses[id].to_s
				end
				
				if id = invoice["company_address"]
					invoice["company_address"] = @addresses[id].to_s
				end
				
				if id = invoice["account"]
					invoice["account"] = @accounts[id].to_s
				end
				
				instance.assign(invoice)
				
				instance.save(dataset)
			end
			
			@documents["invoice/transaction"].each do |transaction|
				instance = Financier::Invoice::Transaction.create(dataset)
				
				if id = transaction["invoice"]
					transaction["invoice"] = @invoices[id].to_s
				end
				
				instance.assign(transaction)
				
				instance.save(dataset)
			end
		end
	end
end
