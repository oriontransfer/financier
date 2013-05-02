
require 'financier/view_formatter'

module Financier
	class FormFormatter < ViewFormatter
		def resource(object)
			object.to_s
		end
		
		def object
			@options[:object]
		end
		
		def name_for(options)
			options[:field] || title_for(options).downcase.gsub(/\s+/, '_').to_sym
		end
		
		def title_for(options)
			options[:title] || options[:field].to_s.to_title
		end
		
		def value_for(options)
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
			
			if options[:type] == 'currency'
				buffer << 'pattern="\d+(\.\d+)? \w{3}"'
			end
			
			buffer.join(' ')
		end
	
		def input(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<dt>#{title_for(options)}</dt>
			<dd><input type="#{options[:type] || 'text'}" name="#{name_for(options)}" value="#{value_for(options)}" #{attributes_for(options)}/></dd>
			EOF
		end
	
		def textarea(options = {})
			options = @options.merge(options)
			
			<<-EOF
			<dt>#{title_for(options)}</dt>
			<dd><textarea name="#{name_for(options)}" #{attributes_for(options)}>#{value_for(options)}</textarea></dd>
			EOF
		end
	
		def checkbox(options)
			options = @options.merge(options)
			name = name_for(options)
			
			checked = options[:object].send(name) ? 'checked' : ''
		
			<<-EOF
			<dd><input type="hidden" name="#{name_for(options)}" value="false" />
				<input type="#{options[:type] || 'checkbox'}" name="#{name}" value="true" #{checked} #{attributes_for(options)}/> #{title_for(options)}
			</dd>
			EOF
		end
		
		def item(options = {})
			options[:field] ||= 'id'
			options[:object] ||= @select_item
			
			<<-EOF
				<option value="#{value_for(options)}" #{attributes_for(options)}>#{title_for(options).to_html}</option>
			EOF
		end
		
		alias option item
		
		def items_for(options)
			buffer = []
			
			if options[:optional]
				buffer << self.item(:value => '', :title => '')
			end
			
			options[:collection].each do |item|
				@select_item = item
				buffer << (yield item)
			end
			
			return buffer.join('')
		end
		
		def item_group(options = {}, &block)
			options = @options.merge(options)
			
			<<-EOF
			<optgroup label="#{title_for(options)}">#{items_for(options, &block)}</optgroup>
			EOF
		end
		
		alias option_group item_group
		
		class Select
			def initialize(formatter, options)
				@formatter = formatter
				@object = formatter.object
				@field = options[:field]
			end
			
			def attributes_for(options)
				buffer = []
				
				if options[:selected]
					buffer << "checked"
				end
				
				return buffer.join(' ')
			end
			
			def item(options = {}, &block)
				if block_given?
					buffer = Trenni::buffer(block.binding)

					buffer.push <<-EOF
						<tr>
							<td class="handle"><input type="radio" name="#{@field}" value="#{@formatter.value_for(options)}" #{attributes_for(options)}/></td>
							<td class="item">
					EOF

					block.call

					buffer.push <<-EOF
							</td>
						</tr>
					EOF
				else
					<<-EOF
					<tr>
						<td class="handle"><input type="radio" name="#{@field}" value="#{@formatter.value_for(options)}" #{attributes_for(options)}/></td>
						<td class="item">#{@formatter.title_for(options)}</td>
					</tr>
					EOF
				end
			end
		end
		
		def select(options = {}, &block)
			options = @options.merge(options)
			
			if options[:type] == :radio
				buffer = Trenni::buffer(block.binding)
				
				buffer.push <<-EOF
				<dt>#{title_for(options)}</dt>
				<dd>
					<table>
				EOF
				
				yield Select.new(self, options)
				
				buffer.push <<-EOF
					</table>
				</dd>
				EOF
			else
				<<-EOF
				<dt>#{title_for(options)}</dt>
				<dd><select name="#{name_for(options)}" #{attributes_for(options)}>#{items_for(options, &block)}</select></dd>
				EOF
			end
		end
		
		def submit(options = {})
			options = @options.merge(options)
			
			unless options[:field]
				options[:title] ||= self.object.saved? ? 'Update' : 'Create'
			end
			
			<<-EOF
			<input type="#{options[:type] || 'submit'}" name="#{name_for(options)}" value="#{title_for(options)}" />
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
