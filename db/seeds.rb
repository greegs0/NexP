# db/seeds.rb
# Orchestrateur de seeds selon l'environnement

# Usage:
#   rails db:seed                 # Utilise l'environnement Rails courant
#   rails db:seed RAILS_ENV=development
#   rails db:seed RAILS_ENV=production

require_relative "seeds/development"
require_relative "seeds/production"

puts ""
puts "=" * 60
puts "NexP Database Seeding"
puts "Environment: #{Rails.env}"
puts "=" * 60
puts ""

case Rails.env
when "production"
  seed_production
when "development", "test"
  seed_development
else
  puts "Unknown environment: #{Rails.env}"
  puts "Using development seeds by default..."
  seed_development
end
