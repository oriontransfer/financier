
require 'bcrypt'

require 'financier/database'
require 'relaxo/model/properties/bcrypt'

module Financier
	class User
		include Relaxo::Model
		
		property :id, UUID
		property :name
		property :password, Attribute[BCrypt::Password]
		
		property :logged_in_at, Optional[Attribute[DateTime]]
		
		view :all, :type, index: :id
		view :by_name, :type, 'by_name', index: unique(:name)
	end
end
