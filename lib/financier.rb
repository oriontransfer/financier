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

require 'utopia'

require 'trenni'
require 'trenni/uri'

require 'yaml'

require_relative 'financier/database'

require_relative 'financier/account'
require_relative 'financier/address'
require_relative 'financier/company'
require_relative 'financier/customer'
require_relative 'financier/invoice'
require_relative 'financier/service'
require_relative 'financier/timesheet'
require_relative 'financier/billing'

require_relative 'financier/calendar'

require_relative 'financier/view_formatter'
require_relative 'financier/form_formatter'
require_relative 'financier/user'

require 'ofx'
require 'qif'
require 'csv'

require 'bigdecimal'

# A monkey patch to fix ofx:
class BigDecimal
	def self.new(*arguments)
		BigDecimal(*arguments)
	end
end

CSV::Converters[:blank_to_nil] = lambda do |field|
	field && field.empty? ? nil : field
end
