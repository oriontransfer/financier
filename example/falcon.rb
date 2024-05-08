#!/usr/bin/env -S falcon host
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2022, by Samuel Williams.

require 'falcon/environment/rack'
require 'falcon/environment/tls'
require 'falcon/environment/lets_encrypt_tls'

hostname = File.basename(__dir__)

service hostname do
	include Falcon::Environment::Rack
	include Falcon::Environment::TLS
	include Falcon::Environment::LetsEncryptTLS
end
