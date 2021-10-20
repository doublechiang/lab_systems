# use 'bundle install' to install the required gem

source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'
gem 'rerun'
gem 'session'
gem 'rake'
gem 'sinatra-activerecord'
gem 'activerecord', '~> 5.2'
# gem 'activerecord'
gem 'will_paginate'
gem 'emk-sinatra-url-for'

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'rspec'
  gem 'rack-test'
  gem "rspec-html-matchers"
  gem 'sqlite3'

end
