
require_relative 'website_context'

# Learn about best practice specs from http://betterspecs.org
RSpec.describe "my website" do
	include_context "website"
	
	it "should redirect to the login page" do
		get "/"
		
		follow_redirect!
		
		expect(last_response.status).to be == 302
		expect(last_response.headers["Location"]).to be == "/login"
	end
end
