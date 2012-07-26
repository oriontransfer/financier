
require 'financier/view_formatter'

module Financier
	class FormFormatter < ViewFormatter
		def object
			@options[:object]
		end
		
		def name_for(options = {})
			options[:name] || options[:title].downcase.gsub(/\s+/, '_').to_sym
		end
		
		def value_for(options = {})
			value = options[:value]
			
			if options[:object]
				value ||= options[:object].send(name_for(options))
			end
		
			self.format(value, options)
		end
		
		def attributes_for(options)
			buffer = []
			
			if options[:required]
				buffer << "required"
			end
			
			if options[:selected]
				buffer << "selected"
			end
			
			buffer.join(' ')
		end
	
		def input(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<dt>#{options[:title]}</dt>
			<dd><input type="#{options[:type] || 'text'}" name="#{name_for(options)}" value="#{value_for(options)}" #{attributes_for(options)}/></dd>
			EOF
		end
	
		def textarea(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<dt>#{options[:title]}</dt>
			<dd><textarea name="#{name_for(options)}" #{attributes_for(options)}>#{value_for(options)}</textarea></dd>
			EOF
		end
	
		def checkbox(options)
			options = @options.merge(options)
			checked = options[:object].send(options[:name]) ? 'checked' : ''
		
			<<-EOF
			<dt>#{options[:title]}</dt>
			<dd><input type="hidden" name="#{options[:name]}" value="false" />
				<input type="#{options[:type] || 'text'}" name="#{name_for(options)}" value="true" #{checked} #{attributes_for(options)}/>
			</dd>
			EOF
		end
		
		def option(options = {})
			options[:name] ||= 'id'
			options[:object] ||= @select_item
			
			<<-EOF
				<option value="#{value_for(options)}" #{attributes_for(options)}>#{options[:title].to_html}</option>
			EOF
		end
		
		def select(options = {})
			options = @options.merge(options)
			collection = options[:collection] || options[:object].send(options[:name])
			
			buffer = []
			
			collection.each do |item|
				@select_item = item
				
				buffer << (yield item)
			end
			
			<<-EOF
			<dt>#{options[:title]}</dt>
			<dd><select name="#{name_for(options)}" #{attributes_for(options)}>
					#{buffer.join('')}
				</select>
			</dd>
			EOF
		end
		
		def submit(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<input type="#{options[:type] || 'submit'}" name="#{name_for(options)}" value="#{options[:title]}" />
			EOF
		end
		
		def hidden(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<input type="#{options[:type] || 'hidden'}" name="#{name_for(options)}" value="#{value_for(options)}" />
			EOF
		end
	end
end
