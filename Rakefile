require "rake"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "-I app/routes -I . -I lib --format documentation"
end
task default: :spec


