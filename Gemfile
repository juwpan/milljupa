source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.3"
gem 'rails_admin'

gem "devise"
gem "devise-i18n"
gem "rails-i18n"
gem 'russian'

# gem 'uglifier'

gem 'font-awesome-sass'
# gem 'font-awesome-rails'

gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap"
gem "puma", "~> 5.0"

group :development do
  gem 'sqlite3', '~> 1.4'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'factory_bot'
  gem 'shoulda-matchers'
  # Гем, который использует rspec, чтобы смотреть наш сайт
  gem 'capybara'
  # Гем, который позволяет смотреть, что видит capybara
  gem 'launchy'
end

group :test do
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :production do
  gem "pg", "~> 1.1"
  gem 'rails_12factor'
end

gem 'redis', '~> 4.0'
gem "sassc-rails"
