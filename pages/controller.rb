
prepend Actions

on 'login' do |request, path|
	if request.post?
		user = Financier::User.fetch_by_name(Financier::DB.current, name: request[:name])
		
		if user && user.password == request[:password]
			request.session[:user_id] = user.id
			
			Financier::DB.commit(message: "User Login") do |dataset|
				user.logged_in_at = Time.now
				
				user.save(dataset)
			end
			
			if request.params[:to]
				redirect request.params[:to]
			else
				redirect! "/customers/index"
			end
		else
			
			$stderr.puts "User authentication failed: #{YAML::dump(request.params)} for user #{YAML::dump(user)}."
			fail! :unauthorized
		end
	end
end

on 'logout' do |request, path|
	request.session[:user_id] = nil
	
	redirect! "/login"
end

PUBLIC = Set.new [
	'_static',
	'login',
	'errors',
]

def public_path? path
	PUBLIC.include? path[0]
end

on '**' do |request, path|
	if user_id = request.session[:user_id]
		@user = Financier::User.fetch_all(Financier::DB.current, id: user_id)
	else
		@user = nil
	end
	
	unless @user or public_path?(path)
		redirect! Trenni::URI("/login", to: request.url)
	end
end
