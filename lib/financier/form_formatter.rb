
require 'financier/view_formatter'

require 'trenni/formatters/html/definition_list_form'
require 'trenni/formatters/html/option_select'
require 'trenni/formatters/html/radio_select'

module Financier
	class FormFormatter < ViewFormatter
		include Trenni::Formatters::HTML::DefinitionListForm
		
		def format_unspecified(object, options)
			object.to_s
		end
		
		unmap(Latinum::Resource)
		
		def select(options = {}, &block)
			element(Trenni::Formatters::HTML::OptionSelect, options, &block)
		end
		
		def radio_select(**options, &block)
			element(Trenni::Formatters::HTML::RadioSelect, options, &block)
		end
	end
end
