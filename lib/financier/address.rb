# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'database'

module Financier
	class Company; end
	class Customer; end
	
	class Address
		include Relaxo::Model
		
		property :id, UUID
		
		property :attention
		property :unit
		property :street
		property :suburb
		property :city
		property :region
		property :postcode
		property :country
		
		property :phone
		property :email
		
		property :purpose
		property :principal, Polymorphic[Company, Customer]
		
		property :created_date, Attribute[Date]
		property :updated_date, Attribute[Date]
		property :last_used_date, Optional[Attribute[Date]]
		
		def after_create
			self.created_date = Date.today
		end
		
		def before_save
			self.updated_date = Date.today
		end
		
		# relationship :addresses, 'financier/address_by_company', Address
		
		view :all, :type, index: :id
		view :by_principal, index: unique(:attention, :id)
	end
end
