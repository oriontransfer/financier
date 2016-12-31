
namespace :relaxo do
	task :setup => :environment do
		design_document_path = File.expand_path('../lib/financier.yaml', __dir__)
		design_document = YAML::load_file(design_document_path)
		
		Financier::DB.save(design_document)
	end
end
