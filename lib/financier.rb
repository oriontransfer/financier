
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

Relaxo::Client.debug = true

$site_config = YAML::load_file('site.yaml')

# Configure the database connection:
Financier::DB = Relaxo.connect($site_config['database-uri'])

# Setup initial admin user:
admin_user = Financier::User.by_name(Financier::DB, :key => "admin")

unless admin_user.first
	admin_user = Financier::User.create(Financier::DB, :name => "admin")
	admin_user.assign(:password => "admin")
	admin_user.save
	
	$stderr.puts "Creating admin user with id: #{admin_user.id}."
else
	$stderr.puts "User accounts functioning normally."
end
