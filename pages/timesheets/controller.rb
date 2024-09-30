
prepend Actions

PARAMETERS = {
	name: true,
	description: true,
	color: true,
	price: true,
	exchange_rate: true,
	exchange_name: true,
	tax_code: true,
	tax_rate: true,
}

on 'delete' do |request, path|
	fail!(:forbidden) unless request.post?
	
	documents = request.params[:rows].values
	
	Financier::DB.commit(message: "Delete Timesheets") do |dataset|
		documents.each do |document|
			timesheet = Financier::Timesheet.fetch_all(dataset, id: document['id'])
			timesheet.delete(dataset)
		end
	end
	
	succeed!
end

on 'new' do |request, path|
	@timesheet = Financier::Timesheet.create(Financier::DB.current)
	
	if request.post?
		@timesheet.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "New Timesheet") do |dataset|
			@timesheet.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'edit' do |request, path|
	@timesheet = Financier::Timesheet.fetch_all(Financier::DB.current, id: request.params[:id])
	
	if request.post?
		@timesheet.assign(request.params, PARAMETERS)
		
		Financier::DB.commit(message: "Edit Timesheet") do |dataset|
			@timesheet.save(dataset)
		end
		
		redirect! "index"
	end
end

on 'show' do |request, path|
	@timesheet = Financier::Timesheet.fetch_all(Financier::DB.current, id: request.params[:id])
end

on 'calendar' do |request|
	@today = Time::Zone.now(@user.timezone).to_date
	
	if start_date = request.params[:start_date]
		@start_date = Date.parse(start_date)
	else
		today = Date.today
		@start_date = today - today.day + 1
	end
	
	if end_date = request.params[:end_date]
		@end_date = Date.parse(end_date)
	elsif days = request.params[:days]
		@end_date = @start_date + Integer(days)
	else
		@end_date = @start_date.next_month
	end
	
	# TODO improve the efficiency of this query?
	@entries = Financier::Timesheet::Entry.all(Financier::DB.current).group_by(&:date)
	
	@calendar = Financier::Calendar.new(@start_date, @end_date)
end

on 'invoice' do |request, path|
	@start_date = Date.parse(request.params[:start_date])
	@end_date = Date.parse(request.params[:end_date])
	
	@calendar = Financier::Calendar.new(@start_date, @end_date)
	
	if billing_customer = request.params[:billing_customer]
		@billing_customer = Financier::Customer.fetch(Financier::DB.current, billing_customer)
	end
	
	if request.post? and entries = request.params[:entries]
		invoice = nil
		@entries = entries.map{|id| Financier::Timesheet::Entry.fetch(Financier::DB.current, id)}
		
		Financier::DB.commit(message: "Create Invoice for Timesheet Entries") do |dataset|
			invoice = Financier::Timesheet.generate_invoice(dataset, @entries,
				name: "Work from #{@calendar.start_date} to #{@calendar.end_date}",
				customer: @billing_customer
			)
		end
		
		redirect! "../invoices/show?id=#{invoice.id}"
	else
		@entries = Financier::Timesheet::Entry.all(Financier::DB.current).to_a
	
		# TODO improve efficiency?
		@entries.delete_if{|entry| entry.invoice? or !@calendar.include?(entry.date)}
	end
end
