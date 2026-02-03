source "https://rubygems.org"

ruby "3.3.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.6"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# additional gems
gem "devise"
gem "kaminari"
gem "rack-attack"
gem "rails-html-sanitizer"
gem "jwt"
gem "active_storage_validations"
gem "image_processing", "~> 1.2"
gem "attr_encrypted", "~> 4.0"

# AWS SDK for S3-compatible storage (Cloudflare R2)
gem "aws-sdk-s3", require: false

# OAuth integrations (problème réseau - à réessayer plus tard)
# gem "omniauth"
# gem "omniauth-github"
# gem "omniauth-gitlab"
# gem "omniauth-rails_csrf_protection"

# API clients (problème réseau - à réessayer plus tard)
# gem "octokit" # GitHub API
# gem "gitlab" # GitLab API

# Redis for caching, Action Cable, and Sidekiq
gem "redis", ">= 4.0.1"

# Sidekiq for background jobs
gem "sidekiq", "~> 7.0"
gem "connection_pool", "~> 2.4"  # Pin to 2.x for Sidekiq compatibility

# Sentry for error monitoring (gratuit jusqu'à 5k errors/mois)
gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-sidekiq"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Load environment variables from .env file
gem "dotenv-rails", groups: [:development, :test]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Preview emails in browser instead of sending them
  gem "letter_opener"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
