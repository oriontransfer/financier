#!/usr/bin/env rackup
# frozen_string_literal: true

require_relative "config/environment"

require "financier/middleware"

Financier::Middleware.call(self, utopia: UTOPIA)
