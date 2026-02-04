# db/seeds/badges.rb
# Badges de référence pour NexP
# Organisés par catégories pour une progression claire

BADGES_DATA = [
  # ═══════════════════════════════════════════════════════════════════════════
  # 🎯 PROGRESSION - Niveaux et XP
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "🌱 Newcomer", description: "Bienvenue sur NexP ! Premier pas dans l'aventure.", xp_required: 0, category: "progression" },
  { name: "⭐ Rising Star", description: "A atteint le niveau 5", xp_required: 500, category: "progression" },
  { name: "💫 Shooting Star", description: "A atteint le niveau 10", xp_required: 1000, category: "progression" },
  { name: "🌟 Bright Star", description: "A atteint le niveau 20", xp_required: 2500, category: "progression" },
  { name: "✨ Super Star", description: "A atteint le niveau 30", xp_required: 5000, category: "progression" },
  { name: "🌠 Megastar", description: "A atteint le niveau 50", xp_required: 10000, category: "progression" },
  { name: "💎 Diamond", description: "A atteint le niveau 75", xp_required: 20000, category: "progression" },
  { name: "👑 Royalty", description: "A atteint le niveau 100", xp_required: 50000, category: "progression" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 🚀 PROJETS - Création et réalisation
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "🚀 First Launch", description: "A créé son premier projet", xp_required: 0, category: "projects" },
  { name: "🎯 Project Starter", description: "A créé 3 projets", xp_required: 200, category: "projects" },
  { name: "📦 Project Machine", description: "A créé 10 projets", xp_required: 1000, category: "projects" },
  { name: "🏭 Project Factory", description: "A créé 25 projets", xp_required: 3000, category: "projects" },
  { name: "✅ First Win", description: "A complété son premier projet", xp_required: 100, category: "projects" },
  { name: "🔥 On Fire", description: "A complété 5 projets", xp_required: 500, category: "projects" },
  { name: "💪 Unstoppable", description: "A complété 10 projets", xp_required: 1500, category: "projects" },
  { name: "🏆 Project Legend", description: "A complété 25 projets", xp_required: 5000, category: "projects" },
  { name: "🎖️ Centurion", description: "A complété 100 projets", xp_required: 25000, category: "projects" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 🤝 ÉQUIPE - Collaboration et leadership
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "🤝 Team Player", description: "A rejoint 3 projets en tant que membre", xp_required: 100, category: "team" },
  { name: "👥 Squad Goals", description: "A rejoint 10 projets en équipe", xp_required: 500, category: "team" },
  { name: "🎪 Team Builder", description: "A recruté 5 membres dans ses projets", xp_required: 300, category: "team" },
  { name: "🦸 Super Recruiter", description: "A recruté 25 membres au total", xp_required: 1500, category: "team" },
  { name: "👨‍✈️ Captain", description: "A dirigé 5 projets complétés", xp_required: 2000, category: "team" },
  { name: "🎖️ Commander", description: "A dirigé 15 projets complétés", xp_required: 5000, category: "team" },
  { name: "🫡 General", description: "A dirigé 50 projets complétés", xp_required: 15000, category: "team" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 💬 SOCIAL - Communication et communauté
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "💬 Chatterbox", description: "A envoyé 50 messages", xp_required: 50, category: "social" },
  { name: "📢 Communicator", description: "A envoyé 200 messages", xp_required: 200, category: "social" },
  { name: "🗣️ Social Butterfly", description: "A envoyé 1000 messages", xp_required: 1000, category: "social" },
  { name: "📝 First Post", description: "A publié son premier post", xp_required: 10, category: "social" },
  { name: "✍️ Blogger", description: "A publié 10 posts", xp_required: 200, category: "social" },
  { name: "📰 Influencer", description: "A publié 50 posts", xp_required: 1000, category: "social" },
  { name: "❤️ Liked", description: "A reçu 10 likes sur ses posts", xp_required: 100, category: "social" },
  { name: "🔥 Popular", description: "A reçu 100 likes sur ses posts", xp_required: 500, category: "social" },
  { name: "🌟 Community Champion", description: "A reçu 500 likes sur ses posts", xp_required: 2000, category: "social" },
  { name: "👋 Networker", description: "A contacté 10 utilisateurs différents", xp_required: 200, category: "social" },
  { name: "🌐 Connected", description: "A contacté 50 utilisateurs différents", xp_required: 1000, category: "social" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 🛠️ SKILLS - Expertise technique
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "🛠️ Jack of Trades", description: "A ajouté 5 skills à son profil", xp_required: 50, category: "skills" },
  { name: "🔧 Versatile", description: "A ajouté 15 skills à son profil", xp_required: 200, category: "skills" },
  { name: "🧰 Swiss Army Knife", description: "A ajouté 30 skills à son profil", xp_required: 500, category: "skills" },
  { name: "👨‍💻 Code Ninja", description: "Expert Backend (Ruby, Python, Node.js...)", xp_required: 1500, category: "skills" },
  { name: "🎨 Design Master", description: "Expert en UI/UX et Design", xp_required: 1500, category: "skills" },
  { name: "📱 Mobile Guru", description: "Expert en développement mobile", xp_required: 1500, category: "skills" },
  { name: "☁️ Cloud Architect", description: "Expert DevOps et Cloud", xp_required: 1500, category: "skills" },
  { name: "🧠 AI Pioneer", description: "Expert en Intelligence Artificielle", xp_required: 2000, category: "skills" },
  { name: "🔐 Security Expert", description: "Expert en cybersécurité", xp_required: 2000, category: "skills" },
  { name: "⛓️ Blockchain Wizard", description: "Expert Web3 et Blockchain", xp_required: 2000, category: "skills" },
  { name: "🎮 Game Dev Hero", description: "Expert en développement de jeux", xp_required: 2000, category: "skills" },
  { name: "🗄️ Data Sage", description: "Expert en bases de données et Data", xp_required: 1500, category: "skills" },
  { name: "⚛️ Frontend Wizard", description: "Expert Frontend (React, Vue, Angular...)", xp_required: 1500, category: "skills" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 🏅 SPÉCIAL - Achievements rares
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "🌅 Early Bird", description: "Membre depuis les débuts de NexP", xp_required: 0, category: "special" },
  { name: "🦄 Unicorn", description: "A créé un projet avec 10+ membres", xp_required: 1000, category: "special" },
  { name: "⚡ Speed Runner", description: "A complété un projet en moins d'une semaine", xp_required: 500, category: "special" },
  { name: "🎯 Perfectionist", description: "A complété 5 projets sans aucun membre quittant", xp_required: 1500, category: "special" },
  { name: "🌈 All-Rounder", description: "A des skills dans 5+ catégories différentes", xp_required: 800, category: "special" },
  { name: "🔄 Comeback Kid", description: "Est revenu actif après 30 jours d'absence", xp_required: 200, category: "special" },
  { name: "🎁 Generous", description: "A aidé 10+ projets sans être owner", xp_required: 1000, category: "special" },
  { name: "🏹 Sniper", description: "A été accepté dans 10 projets consécutifs", xp_required: 800, category: "special" },
  { name: "💡 Innovator", description: "A lancé un projet dans une catégorie rare", xp_required: 500, category: "special" },
  { name: "🎓 Mentor", description: "A aidé 5 nouveaux membres à compléter leur premier projet", xp_required: 2000, category: "special" },

  # ═══════════════════════════════════════════════════════════════════════════
  # 🗓️ ACTIVITÉ - Régularité et engagement
  # ═══════════════════════════════════════════════════════════════════════════
  { name: "📅 Consistent", description: "Actif 7 jours consécutifs", xp_required: 100, category: "activity" },
  { name: "🔥 Hot Streak", description: "Actif 30 jours consécutifs", xp_required: 500, category: "activity" },
  { name: "💯 Dedicated", description: "Actif 100 jours consécutifs", xp_required: 2000, category: "activity" },
  { name: "🗓️ Veteran", description: "Membre depuis 6 mois", xp_required: 500, category: "activity" },
  { name: "🏛️ OG", description: "Membre depuis 1 an", xp_required: 1500, category: "activity" },
  { name: "⏰ Night Owl", description: "A contribué entre minuit et 5h du matin", xp_required: 100, category: "activity" },
  { name: "☀️ Early Riser", description: "A contribué avant 7h du matin", xp_required: 100, category: "activity" }
].freeze

BADGE_CATEGORIES = {
  "progression" => "🎯 Progression",
  "projects" => "🚀 Projets",
  "team" => "🤝 Équipe",
  "social" => "💬 Social",
  "skills" => "🛠️ Skills",
  "special" => "🏅 Spécial",
  "activity" => "🗓️ Activité"
}.freeze

def seed_badges
  puts "Création des badges..."

  all_badges = BADGES_DATA.map do |badge_data|
    Badge.find_or_create_by!(name: badge_data[:name]) do |b|
      b.description = badge_data[:description]
      b.xp_required = badge_data[:xp_required]
      b.category = badge_data[:category]
    end
  end

  categories_count = BADGES_DATA.map { |b| b[:category] }.uniq.count
  puts "  #{Badge.count} badges créés dans #{categories_count} catégories"
  all_badges
end
