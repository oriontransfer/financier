
require 'digest'

def on_login_salt(path, request)
	sleep(0.5 + rand * 0.5)
	
	name = request[:name].to_s
	
	user = Financier::User.by_name(Financier::DB, :key => name).first
	
	if user == nil
		fail! :forbidden
	else
		salt = SecureRandom.hex
		request.session[:login_salt] = salt
		
		$stderr.puts "Responding with login_salt #{user.password_salt},#{salt} for user name = #{name}"
		
		respond! :code => :success, :content => "#{user.password_salt},#{salt}"
	end
end

def on_login(path, request)
	if request.post?
		name = request[:name]
		password = request[:password]
		login_digest = request[:login_digest]
		login_salt = request.session[:login_salt]
		
		success = false
		
		user = Financier::User.by_name(Financier::DB, :key => name).first
		
		if user && login_digest
			success = user.digest_authenticate(login_digest, login_salt)
		elsif user && password
			success = user.plaintext_authenticate(password)
		end
		
		# If no login method was successful, nullify the user
		user = nil unless success
		
		if user
			request.session[:user] = user.id
		
			redirect! "/customers/index"
		else
			LOG.debug("User #{name} (#{password.inspect} / #{login_digest.inspect}) was not logged in.")
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
