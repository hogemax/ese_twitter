source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

gem 'rails', '~> 5.1.6'

#gem 'sqlite3', group: [:development, :test]
gem 'sqlite3', '~> 1.3.6', group: [:development, :test]
gem 'pg', group: :production

gem "puma", ">= 3.12.2"
#gem 'sass-rails', '~> 5.0'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem "rack", ">= 2.0.8"

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem "loofah", ">= 2.3.1"

gem 'nokogiri', '~> 1.10.10'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
  gem 'brakeman', :require => false
  gem 'bullet'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "devise", ">= 4.7.1"
gem 'omniauth-twitter'
gem "omniauth-rails_csrf_protection"
gem 'carrierwave'
gem 'rmagick'
gem 'bootstrap-sass'
gem 'sprockets'
gem 'font-awesome-rails'
gem 'faker'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'counter_culture'
gem 'cloudinary'
