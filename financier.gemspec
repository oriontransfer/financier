# frozen_string_literal: true

require_relative "lib/financier/version"

Gem::Specification.new do |spec|
	spec.name = "financier"
	spec.version = Financier::VERSION
	
	spec.summary = "A business management application."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.homepage = "https://oriontransfer.github.io/financier"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/oriontransfer/financier/",
	}
	
	spec.files = Dir["{bake,lib,pages,public}/**/*", "*.md", base: __dir__]
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "bcrypt", "~> 3.0"
	spec.add_dependency "csv", "~> 3.0"
	spec.add_dependency "latinum", "~> 1.8"
	spec.add_dependency "markly"
	spec.add_dependency "ofx", "~> 0.3"
	spec.add_dependency "periodical", "~> 1.2"
	spec.add_dependency "qif", "~> 1.1"
	spec.add_dependency "relaxo", "~> 1.7"
	spec.add_dependency "relaxo-model", "~> 0.19"
	spec.add_dependency "time-zone", "~> 1.1"
	spec.add_dependency "tty-prompt"
	spec.add_dependency "utopia", "~> 2.18"
	spec.add_dependency "xrb-formatters"
	spec.add_dependency "xrb-sanitize"
end
