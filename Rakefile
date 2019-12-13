
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:test)

require 'pathname'
SITE_ROOT = Pathname.new(__dir__).realpath

# Load all rake tasks:
import(*Dir.glob('tasks/**/*.rake'))

task :default => :development
