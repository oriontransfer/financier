
namespace :relaxo do
	task :setup => :environment do
		design_documents_path = File.expand_path('../lib/financier.yaml', __dir__)
		design_documents = YAML::load_file(design_document_path)
		
		design_documents.each do |design_document|
			Financier::DB.save(design_document)
		end
	end
end
