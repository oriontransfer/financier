# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

prepend Actions

PARAMETERS = {
	name: true,
	password: true,
	timezone: true,
}

on "delete" do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params["rows"].values
	
	Financier::DB.commit(message: "Delete Users") do |dataset|
		documents.each do |document|
			user = Financier::User.fetch_all(dataset, id: document["id"])
			user.delete(dataset)
		end
	end
	
	succeed!
end

on "new" do |request, path|
	@user = Financier::User.create(Financier::DB.current)
	
	if request.post?
		@user.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New User") do |dataset|
			@user.save(dataset)
		end
		
		redirect! "index"
	end
end

on "edit" do |request, path|
	@user = Financier::User.fetch_all(Financier::DB.current, id: request.params["id"])
	
	if request.post?
		@user.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit User") do |dataset|
			@user.save(dataset)
		end
		
		redirect! "index"
	end
end
