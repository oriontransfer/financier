
#	This file is part of the "jQuery.Syntax" project, and is distributed under the MIT License.
#	See <jquery.syntax.js> for licensing details.
#	Copyright (c) 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>

require 'stringio'
require 'fileutils'
require 'tmpdir'
require 'pathname'
require 'yaml'

require 'closure-compiler'

LICENSE = <<EOF
// This file is part of the "jQuery.XFrame" project, and is distributed under the MIT License.
EOF

BASE_PATH = Pathname.new(Dir.getwd)
$config = nil

if ENV['PREFIX']
	Dir.chdir(ENV['PREFIX'])
end

# Note... this is one way !
task :compress_all => :setup_prefix do
	files = Dir["*.js"]
	compiler = Closure::Compiler.new
	
	puts "Minifying JavaScript..."
	files.each do |path|
		output = compiler.compile(File.open(path, 'r'))
		File.open(path, 'w') do |file|
			file.write(LICENSE)
			file.write(output)
		end
	end
end

task :setup_prefix do
	if ENV['CONFIG']
		config_path = BASE_PATH + ENV['CONFIG']
	else
		config_path = BASE_PATH + "site.yaml"
		unless File.exist? config_path
			config_path = BASE_PATH + "install.yaml"
		end
	end

	puts "Using configuration #{config_path}"	
	$config = YAML::load_file(config_path)
	
	if $config['prefix'] && !ENV['PREFIX']
		ENV['PREFIX'] = (config_path.dirname + ($config['prefix'] || 'public')).to_s
	elsif ENV['PREFIX']
		ENV['PREFIX'] = BASE_PATH + ENV['PREFIX']
	else
		ENV['PREFIX'] = BASE_PATH + 'public'
	end
	
	prefix = Pathname.new(ENV['PREFIX'])
	prefix.mkpath
	
	Dir.chdir(prefix)
	
	puts "Working in #{Dir.getwd}..."
end

task :install => :setup_prefix do |task, arguments|
	Rake::Task[:clean].invoke(arguments[:config])
	
	js_files = Dir[BASE_PATH + "source/*.js"]
	
	js_files.each do |path|
		output_path = File.basename(path)
		
		FileUtils.cp(path, output_path)
	end
	
	Rake::Task[:compress_all].invoke if $config['minify']
	
	puts "Install into #{Dir.getwd} finished."
end

task :clean => :setup_prefix do |task, arguments|
	Dir.glob("*") do |path|
		FileUtils.rm_r path
	end
end

task :default => :install
