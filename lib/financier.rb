
require 'utopia'
require 'utopia/trenni'

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

require 'utopia/extensions/maybe'

require 'ofx'
require 'qif'

site_config = YAML::load_file('site.yaml')

# Configure the database connection:
Financier::DB = Relaxo.connect(site_config['database-uri'])

