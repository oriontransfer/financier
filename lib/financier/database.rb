
require 'relaxo'
require 'relaxo/session'
require 'relaxo/model'
require 'relaxo/model/properties/bigdecimal'

require 'latinum'
require 'latinum/bank'
require 'latinum/currencies/global'
require 'relaxo/model/properties/latinum'

require 'bigdecimal'
require 'bigdecimal/util'

module Financier
	DB = Relaxo.connect('oriontransfer-financier')
	BANK = Latinum::Bank.new(Latinum::Currencies::Global)
	
	# This needs to be refactored into a configuration file!?
	DEFAULT_TAX_RATE = "0.15".to_d
end