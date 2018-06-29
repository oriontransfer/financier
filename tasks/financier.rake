
namespace :financier do
	namespace :users do
		task :create => :environment do
			require 'tty/prompt'
			
			prompt = TTY::Prompt.new
			
			name = prompt.ask("Login name:", default: 'admin')
			password = prompt.mask("Login password:")
			
			Financier::DB.commit(message: "New User") do |dataset|
				@user = Financier::User.create(dataset)
				
				@user.assign(name: name, password: password)
				
				@user.save(dataset)
			end
		end
	end
	
	namespace :timesheets do
		task :fix_entries => :environment do
			Financier::DB.commit(message: "Fix entries time zone UTC -> Pacific/Auckland") do |changeset|
				Financier::Timesheet::Entry.all(changeset).each do |entry|
					if entry.finished_at.zone == "UTC"
						puts "Fixing entry #{entry.inspect}"
						
						entry.finished_at = entry.finished_at.with_offset(0, 0, "Pacific/Auckland")
						
						entry.save!(changeset)
					end
				end
			end
		end
	end
end
