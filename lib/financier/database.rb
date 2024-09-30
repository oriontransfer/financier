# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

require "relaxo"
require "relaxo/model"
require "relaxo/model/properties/bigdecimal"

require "latinum"
require "latinum/bank"
require "latinum/currencies/global"
require "relaxo/model/properties/latinum"

require "bigdecimal"
require "bigdecimal/util"

module Financier
	BANK = Latinum::Bank.new(Latinum::Currencies::Global)
end
