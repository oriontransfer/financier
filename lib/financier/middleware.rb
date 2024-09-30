# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "database"

require "utopia"
require "utopia/setup"
require "utopia/session"

module Financier
	module Middleware
		# The root directory of the web application files.
		SITE_ROOT = File.expand_path("../..", __dir__)
		
		# The root directory for the utopia middleware.
		PAGES_ROOT = File.expand_path("pages", SITE_ROOT)
		
		# The root directory for static assets.
		PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)
		
		def self.call(builder, utopia: Utopia.setup)
			if utopia.production?
				# Handle exceptions in production with a error page and send an email notification:
				builder.use Utopia::Exceptions::Handler
				builder.use Utopia::Exceptions::Mailer
			else
				# We want to propate exceptions up when running tests:
				builder.use Rack::ShowExceptions unless utopia.testing?
			end
			
			builder.use Utopia::Static, root: PUBLIC_ROOT
			
			builder.use Utopia::Redirection::Rewrite, {
				"/" => "/index"
			}
			
			builder.use Utopia::Redirection::DirectoryIndex
			
			builder.use Utopia::Redirection::Errors, {
				404 => "/errors/file-not-found"
			}
			
			builder.use Utopia::Session,
				expires_after: 3600 * 24,
				secret: utopia.secret_for(:session),
				secure: true
			
			builder.use Utopia::Controller, root: PAGES_ROOT
			builder.use Utopia::Content, root: PAGES_ROOT
			
			builder.run lambda { |env| [404, {}, []] }
		end
		
		def self.to_app
			builder = Rack::Builder.new
			
			self.call(builder)
			
			return builder.to_app
		end
	end
end
