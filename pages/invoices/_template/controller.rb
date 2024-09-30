# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2024, by Samuel Williams.

prepend Actions

PARAMETERS = {
	customer: true,
	company: true,
}

on "company" do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current)
	@invoice.assign(request.params, PARAMETERS)
end

on "customer" do |request, path|
	@invoice = Financier::Invoice.create(Financier::DB.current)
	@invoice.assign(request.params, PARAMETERS)
end
