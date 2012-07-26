
require 'redcarpet'

class BigDecimal
	alias _to_s to_s

	def to_s param = nil
		_to_s param || 'F'
	end
end

module Financier
	MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
	
	class Formatter
		def initialize(options = {})
			@options = options
			@formatters = {}
		end

		def format(object, options = {})
			if formatter = @formatters[object.class]
				@formatters[object.class].call(object, options)
			else
				if object
					object.to_s.to_html
				else
					options[:blank] || ""
				end
			end
		end
		
		def % object
			format(object)
		end
		
		def [] key
			@options[key]
		end
		
		protected
		
		def formatter_for(klass, &block)
			@formatters[klass] = block
		end
		
		def merged_options(options = {})
			@options.merge(options)
		end
	end
end
