
require 'financier/database'

require 'digest'
require 'securerandom'

module Financier
	class User
		include Relaxo::Model
		
		property :name
		
		property :password_salt
		property :password_digest
		
		view :all, 'financier/user', User
		view :by_name, 'financier/user_by_name', User
		
		def secure_digest(key, salt = '')
			return Digest::SHA1.hexdigest(key + salt)
		end
		
		def password= value
			self.password_salt = SecureRandom.hex
			self.password_digest = secure_digest(value, self.password_salt)
		end
		
		def digest(password)
			secure_digest(password, self.password_salt)
		end
		
		def digest_authenticate(login_digest, login_salt)
			return false if password_digest == nil
			
			return login_digest == secure_digest(password_digest, login_salt)
		end

		def plaintext_authenticate(password)
			return false if password_digest == nil
			
			return digest(password) == password_digest
		end
	end
	
end