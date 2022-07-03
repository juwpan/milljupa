# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '~> 7.0.3'
gem 'rails_admin'

gem 'devise'
gem 'devise-i18n'
gem 'rails-i18n'
gem 'russian'

# gem 'uglifier'

gem 'font-awesome-sass'
# gem 'font-awesome-rails'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'bootsnap'
gem 'puma', '~> 5.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'rails-controller-testing'

group :development do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem 'rubocop', '~> 1.31.0'
  gem 'shoulda-matchers'
  gem 'sqlite3', '~> 1.4'
end

group :test do
  gem 'launchy'
  gem 'capybara'
end

group :production do
  gem 'pg', '~> 1.1'
  gem 'rails_12factor'
end

gem 'redis', '~> 4.0'
gem 'sassc-rails'
