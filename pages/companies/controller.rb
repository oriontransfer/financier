# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

prepend Actions

PARAMETERS = {
	name: true,
	role: true,
}

on "delete" do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params[:rows].values
	
	Financier::DB.commit(message: "Delete Companies") do |dataset|
		documents.each do |document|
			company = Financier::Company.fetch_all(dataset, id: document["id"])
			company.delete(dataset)
		end
	end
	
	succeed!
end

on "new" do |request, path|
	@company = Financier::Company.create(Financier::DB.current)
	
	if request.post?
		@company.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Company") do |dataset|
			@company.save(dataset)
		end
		
		redirect! "index"
	end
end

on "edit" do |request, path|
	@company = Financier::Company.fetch_all(Financier::DB.current, id: request.params[:id])
	
	if request.post?
		@company.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Company") do |dataset|
			@company.save(dataset)
		end
		
		redirect! "index"
	end
end

on "index" do |request, path|
	@companies = Financier::Company.all(Financier::DB.current)
end
