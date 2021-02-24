require "rake"
require "rspec/core/rake_task"
require "sinatra/activerecord/rake"


RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "-I app/routes -I . -I lib --format documentation"
end

task default: :spec

desc 'copy server lease file & systems database file'
task :development do
  puts "prepare the development env from server."
  system("scp cchiang@10.16.0.1:/var/lib/dhcpd/dhcpd.leases .")
end

namespace :db do
  task :load_config do
    require "./lab_systems"
  end
end


