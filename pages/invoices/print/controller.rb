# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2014-2024, by Samuel Williams.

prepend Actions

on "full" do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request.params[:id])
end

on "plain" do |request, path|
	@invoice = Financier::Invoice.fetch_all(Financier::DB.current, id: request.params[:id])
end

