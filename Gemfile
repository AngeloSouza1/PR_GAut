source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Rails framework
gem "rails", "~> 7.1.0"

# Asset pipeline for Rails
gem "sprockets-rails"

# PostgreSQL database adapter
gem "pg", "~> 1.1"

# Puma web server
gem "puma", "~> 6.0"


# Import maps for JavaScript
gem "importmap-rails"

# Hotwire for SPA-like functionality
gem "turbo-rails"
gem "stimulus-rails"

# Build JSON APIs
gem "jbuilder"

# Caching; required in config/boot.rb
gem "bootsnap", require: false

# Use bcrypt for secure passwords
gem "bcrypt", "~> 3.1.7"

# Windows timezone info (only include if Windows is used)
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  # Debugging tools
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Web console for development
  gem "web-console", "~> 4.0"

  # Spring for fast commands (uncomment if needed)
  # gem "spring"
end

group :test do
  # System testing tools
  gem "capybara"
  gem "selenium-webdriver"
end
