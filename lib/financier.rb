
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

require_relative 'financier/calendar'

require_relative 'financier/view_formatter'
require_relative 'financier/form_formatter'
require_relative 'financier/user'

require 'ofx'
require 'qif'
require 'csv'

CSV::Converters[:blank_to_nil] = lambda do |field|
	field && field.empty? ? nil : field
end
