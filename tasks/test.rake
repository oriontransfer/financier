
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |task|
	task.rspec_opts = %w{--require simplecov} if ENV['COVERAGE']
end

RSpec::Core::RakeTask.new(:unit_test) do |task|
	task.rspec_opts = %w{--require simplecov} if ENV['COVERAGE']
	task.pattern = task.pattern.gsub('_spec', '_unit_spec')
end

task :coverage do
	ENV['COVERAGE'] = 'y'
end
