# db/seeds/production.rb
# Seeds pour environnement de production
# Contient uniquement les données de référence et le compte admin

require_relative "skills"
require_relative "badges"

def seed_production
  puts "🌱 Seeding PRODUCTION..."
  puts ""

  # 1. Skills (données de référence)
  all_skills = seed_skills

  # 2. Badges (données de référence)
  seed_badges

  # 3. Compte admin (uniquement si n'existe pas déjà)
  puts "Création du compte admin..."

  admin_email = ENV.fetch("ADMIN_EMAIL", "greg@nexp.dev")
  admin_password = ENV.fetch("ADMIN_PASSWORD") { raise "ADMIN_PASSWORD environment variable required in production" }

  admin = User.find_or_initialize_by(email: admin_email)
  if admin.new_record?
    admin.assign_attributes(
      password: admin_password,
      password_confirmation: admin_password,
      name: "Grégory Lefebvre",
      username: "greegs0",
      bio: "Founder @NexP",
      zipcode: "75001",
      experience_points: 0,
      level: 1,
      available: true,
      confirmed_at: Time.current,
      plan: "builder"
    )
    admin.save!

    # Associer quelques skills de base
    %w[Ruby\ on\ Rails PostgreSQL JavaScript].each do |skill_name|
      if all_skills[skill_name]
        UserSkill.find_or_create_by!(user: admin, skill: all_skills[skill_name])
      end
    end

    puts "  Compte admin créé: #{admin_email}"
  else
    puts "  Compte admin existe déjà: #{admin_email}"
  end

  puts ""
  puts "✅ Seed production terminée !"
  puts "   - #{Skill.count} skills"
  puts "   - #{Badge.count} badges"
  puts "   - #{User.count} utilisateur(s)"
end
