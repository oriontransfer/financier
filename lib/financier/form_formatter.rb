# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require_relative "view_formatter"

require "xrb/formatters/html/definition_list_form"
require "xrb/formatters/html/option_select"
require "xrb/formatters/html/radio_select"

module Financier
	class FormFormatter < ViewFormatter
		include XRB::Formatters::HTML::DefinitionListForm
		
		def format_unspecified(object, options)
			object.to_s
		end
		
		unmap(Latinum::Resource)
		
		def select(options = {}, &block)
			element(XRB::Formatters::HTML::OptionSelect, **options, &block)
		end
		
		def radio_select(**options, &block)
			element(XRB::Formatters::HTML::RadioSelect, **options, &block)
		end
	end
end
