
on 'login' do |request, path|
	if request.post?
		user = Financier::User.by_name(Financier::DB, :key => request[:name].to_s).first
		
		if user && user.password == request[:password]
			request.session[:user] = user.id
			
			redirect! "/customers/index"
		else
			LOG.debug("User authentication failed: #{YAML::dump(request.params)} for user #{YAML::dump(user)}.")
			fail! :unauthorized
		end
	end
end

on 'logout' do |request, path|
	request.session[:user] = nil
	
	redirect! "/login"
end

def public_path? path
	path.start_with?(Path["/_static"]) || path.start_with?(Path["/login"])
end

on '**' do |request, path|
	if request.session[:user]
		@user = Financier::User.fetch(Financier::DB, request.session[:user]) rescue nil
	end
	
	unless @user or public_path?(path)
		redirect! "/login"
	end
end
