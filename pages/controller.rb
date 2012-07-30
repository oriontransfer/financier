
def on_login(path, request)
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

def on_logout(path, request)
	request.session[:user] = nil
	
	redirect! "/login"
end

def public_path? path
	path.starts_with?(Path["/_static"]) || path.starts_with?(Path["/login"])
end

def process!(path, request)
	if request.session[:user]
		request.controller[:user] = Financier::User.fetch(Financier::DB, request.session[:user])
	end
	
	if request.session[:user] || public_path?(path)
		passthrough(path, request)
	else
		respond_with :redirect => "/login"
	end
end
