source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.6"

gem "rails", "~> 7.1.3"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# --- CONFIGURACIÓ DE BASES DE DADES ---
group :production do
  gem "pg"
end

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "debug", platforms: %i[ mri windows ]
end
# --------------------------------------

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Gema per connectar amb AWS S3
gem "aws-sdk-s3", require: false

# Gema per carregar variables d'entorn des d'un fitxer .env
gem "dotenv-rails", groups: [:development, :test]