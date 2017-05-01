source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.4'
gem 'rails', '~> 5.0.2'

gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'redis', '~> 3.0'
gem 'devise'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'simple_form'
gem 'interactor', '~> 3.0'
gem 'ransack'
gem 'will_paginate'
gem 'pry'
gem 'record_tag_helper'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # code cleanup
  gem 'rubocop',              require: false
  gem 'traceroute',           require: false
  gem 'bullet'
  gem 'brakeman',             require: false
  gem 'rubycritic',           require: false
  gem 'rails_best_practices', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
end
