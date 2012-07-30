
require 'financier/database'

require 'digest'
require 'bcrypt'
require 'securerandom'

require 'relaxo/model/properties/bcrypt'

module Financier
	class User
		include Relaxo::Model
		
		property :name
		property :password, Attribute[BCrypt::Password]
		
		view :all, 'financier/user', User
		view :by_name, 'financier/user_by_name', User
	end
	
end