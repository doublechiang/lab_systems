require "rake"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "-I app/routes -I . -I lib --format documentation"
end
task default: :spec

task :development do
  # prepare the development env from server.
  system("scp cchiang@10.16.0.1:/var/lib/dhcpd/dhcpd.leases .")
  system("scp cchiang@10.16.0.1:lab_systems/system.yml .")
end


