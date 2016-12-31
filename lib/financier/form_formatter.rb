
require 'financier/view_formatter'

module Financier
	class FormFormatter < ViewFormatter
		include Trenni::Formatters::HTML::DefinitionListForm
		
		map(Latinum::Resource) do |object, options|
			BANK.format(object, **options.fetch(:resource_format, {}))
		end
	end
end
