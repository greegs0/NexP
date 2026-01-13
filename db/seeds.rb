# db/seeds.rb

puts "🧹 Nettoyage de la base..."
ProjectSkill.destroy_all
UserSkill.destroy_all
Skill.destroy_all
Project.destroy_all
User.destroy_all

puts "✅ Base nettoyée !"

# ========================================
# 1️⃣ USER
# ========================================

user = User.create!(
  email: "greg@gmail.com",
  password: "azerty",
  password_confirmation: "azerty",
  name: "Grégory Lefebvre",
  username: "Greegs0",
  bio: "Dev Ruby on Rails & Freelance. Passionné par l'optimisation et l'automatisation.",
  zipcode: "75001",
  github_url: "https://github.com/greegs0",
  linkedin_url: "https://www.linkedin.com/in/gr%C3%A9gory-lefebvre/",
  portfolio_url: "https://gregory-lefebvre.dev/"
)

puts "✅ User créé : #{user.email}"

# ========================================
# 2️⃣ SKILLS
# ========================================

skills_data = {
  "Backend" => [
    "Ruby", "Ruby on Rails", "API REST", "Active Record",
    "Action Cable", "Background Jobs", "Sidekiq"
  ],

  "Frontend" => [
    "HTML", "CSS", "JavaScript", "Stimulus", "Turbo",
    "Hotwire", "Responsive Design", "Bootstrap", "Tailwind"
  ],

  "Database" => [
    "PostgreSQL", "MySQL", "SQLite", "Redis",
    "Optimisation SQL", "Migrations", "Active Storage"
  ],

  "DevOps" => [
    "Docker", "Git", "GitHub", "Heroku", "CI/CD",
    "Deployment", "Linux"
  ],

  "IA" => [
    "RAG", "Prompt Engineering", "OpenAI", "API OpenAI",
    "Intégration IA", "LangChain"
  ],

  "Tools" => [
    "VS Code", "GitHub Actions", "Postman", "RuboCop",
    "Debugging", "RSpec", "Minitest"
  ],

  "Autre" => [
    "SEO", "Optimisation Performances", "Tests",
    "Assurance Qualité", "Architecture MVC", "Sécurité Web"
  ]
}

# Créer toutes les skills
all_skills = {}
skills_data.each do |category, names|
  names.each do |name|
    skill = Skill.find_or_create_by!(name: name) do |s|
      s.category = category
    end
    all_skills[name] = skill
  end
end

puts "✅ #{Skill.count} skills créées dans #{Skill.distinct.count(:category)} catégories"

# Associer QUELQUES skills à l'user (pas toutes, sinon c'est relou à tester)
user_skills_names = [
  "Ruby on Rails", "PostgreSQL", "JavaScript", "Stimulus",
  "Docker", "Git", "RAG", "API OpenAI", "HTML", "CSS"
]

user_skills_names.each do |name|
  UserSkill.create!(user: user, skill: all_skills[name])
end

puts "✅ #{user.user_skills.count} skills associées à #{user.name}"

# ========================================
# 3️⃣ PROJETS
# ========================================

project1 = Project.create!(
  owner: user,
  title: "NexP - Plateforme de matching de projets",
  description: "Plateforme permettant de connecter des développeurs et designers pour monter des projets collaboratifs.",
  status: "in_progress",
  max_members: 5
)

project2 = Project.create!(
  owner: user,
  title: "ChatBot IA avec RAG",
  description: "Assistant conversationnel utilisant l'API OpenAI avec RAG.",
  status: "completed",
  max_members: 2
)

puts "✅ #{Project.count} projets créés"

# Associer skills aux projets
ProjectSkill.create!(project: project1, skill: all_skills["Ruby on Rails"])
ProjectSkill.create!(project: project1, skill: all_skills["PostgreSQL"])
ProjectSkill.create!(project: project1, skill: all_skills["JavaScript"])
ProjectSkill.create!(project: project1, skill: all_skills["Stimulus"])

ProjectSkill.create!(project: project2, skill: all_skills["RAG"])
ProjectSkill.create!(project: project2, skill: all_skills["API OpenAI"])
ProjectSkill.create!(project: project2, skill: all_skills["Prompt Engineering"])

puts "✅ Skills associées aux projets"

# ========================================
# 📊 RÉSUMÉ
# ========================================

puts "\n🎉 SEED TERMINÉE !"
puts "================================"
puts "👤 User : #{user.email}"
puts "⚡ Skills totales : #{Skill.count}"
puts "🔗 Skills de l'user : #{user.user_skills.count}"
puts "🚀 Projets : #{Project.count}"
puts "================================"
