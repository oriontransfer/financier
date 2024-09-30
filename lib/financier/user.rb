# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require "bcrypt"
require "relaxo/model/properties/bcrypt"

require_relative "database"

module Financier
	class User
		include Relaxo::Model
		
		property :id, UUID
		property :name
		property :password, Attribute[BCrypt::Password]
		
		property :logged_in_at, Optional[Attribute[DateTime]]
		
		property :timezone
		
		view :all, :type, index: :id
		view :by_name, :type, "by_name", index: unique(:name)
	end
end
