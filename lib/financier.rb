
require 'utopia'
require 'trenni'

require 'yaml'

require 'financier/database'

require 'financier/account'
require 'financier/address'
require 'financier/company'
require 'financier/customer'
require 'financier/invoice'
require 'financier/service'

require 'financier/view_formatter'
require 'financier/form_formatter'
require 'financier/user'

require 'ofx'
require 'qif'
require 'csv'

CSV::Converters[:blank_to_nil] = lambda do |field|
	field && field.empty? ? nil : field
end
