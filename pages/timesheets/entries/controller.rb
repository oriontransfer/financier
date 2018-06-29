
prepend Actions

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request[:rows].values
	
	Financier::DB.commit(message: "Delete Timesheet Entries") do |dataset|
		documents.each do |document|
			company = Financier::Timesheet::Entry.fetch_all(dataset, id: document['id'])
			company.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@entry = Financier::Timesheet::Entry.create(Financier::DB.current, :duration => 1)
	
	if timesheet_id = request[:timesheet_id]
		@entry.timesheet = Financier::Timesheet.fetch_all(@entry.dataset, id: request[:timesheet_id])
	end
	
	if date = request[:date]
		@entry.finished_at = Time::Zone::Timestamp.parse(date, @user.timezone)
	else
		@entry.finished_at = Time::Zone::Timestamp.now(@user.timezone)
	end
	
	if request.post?
		@entry.assign(request.params)
		
		Financier::DB.commit(message: "New Timesheet Entry") do |dataset|
			@entry.save(dataset)
		end
		
		redirect! "../show?id=#{@entry.timesheet.id}"
	end
end

on 'edit' do |request, path|
	@entry = Financier::Timesheet::Entry.fetch_all(Financier::DB.current, id: request[:id])
	
	if request.post?
		@entry.assign(request.params)
		
		Financier::DB.commit(message: "Edit Timesheet Entry") do |dataset|
			@entry.save(dataset)
		end
		
		redirect! "../show?id=#{@entry.timesheet.id}"
	end
end
