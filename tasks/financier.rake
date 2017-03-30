
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
end
