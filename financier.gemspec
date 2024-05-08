require_relative 'lib/financier/version'

Gem::Specification.new do |spec|
	spec.name = "financier"
	spec.version = Financier::VERSION
	spec.authors = ["Samuel Williams"]
	spec.email = ["samuel.williams@oriontransfer.co.nz"]
	
	spec.summary = "A business management application."
	spec.homepage = "https://oriontransfer.github.io/financier/"
	spec.license = "MIT"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/oriontransfer/financier/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.required_ruby_version = ">= 2.5"
	
	spec.files = Dir['{bake,lib,pages,public}/**/*', base: __dir__]
	spec.require_paths = ["lib"]
	
	spec.add_dependency "utopia", "~> 2.18"
	
	spec.add_dependency "relaxo", "~> 1.3"
	spec.add_dependency "relaxo-model", "~> 0.19"
	
	spec.add_dependency "periodical", "~> 1.0"
	spec.add_dependency "latinum", "~> 1.3"
	
	spec.add_dependency "time-zone", "~> 1.1"
	
	spec.add_dependency "ofx", "~> 0.3"
	spec.add_dependency "qif", "~> 1.1"
	
	spec.add_dependency "bcrypt", "~> 3.0"
	
	spec.add_dependency "xrb-formatters"
	spec.add_dependency "xrb-sanitize"
	spec.add_dependency "markly"
	
	spec.add_dependency "tty-prompt"
	
	spec.add_development_dependency 'covered'
	spec.add_development_dependency 'bundler'
	spec.add_development_dependency 'rspec'
	spec.add_development_dependency 'bake-bundler'
end
