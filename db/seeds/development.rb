# db/seeds/development.rb
# Seeds pour environnement de développement
# Contient toutes les données de test

require_relative "skills"
require_relative "badges"

def seed_development
  puts "🌱 Seeding DEVELOPMENT..."
  puts ""

  puts "Nettoyage de la base..."
  # Clean in reverse order of dependencies
  Like.destroy_all
  Post.destroy_all
  Message.destroy_all
  Team.destroy_all
  ProjectSkill.destroy_all
  UserSkill.destroy_all
  UserBadge.destroy_all
  Badge.destroy_all
  Skill.destroy_all
  Project.destroy_all
  User.destroy_all
  puts "  Base nettoyee !"
  puts ""

  # 1. Skills (donnees de reference)
  all_skills = seed_skills

  # 2. Badges (donnees de reference)
  all_badges = seed_badges

  # 3. Users
  puts "Creation des utilisateurs..."
  all_users = seed_users(all_skills, all_badges)
  puts "  #{User.count} utilisateurs crees"

  # 4. Projects
  puts "Creation des projets..."
  all_projects = seed_projects(all_users, all_skills)
  puts "  #{Project.count} projets crees"

  # 5. Teams
  puts "Creation des teams..."
  seed_teams(all_users, all_projects)
  puts "  #{Team.count} membres ajoutes aux projets"

  # 6. Posts
  puts "Creation des posts..."
  all_posts = seed_posts(all_users)
  puts "  #{Post.count} posts crees"

  # 7. Likes
  puts "Creation des likes..."
  seed_likes(all_users, all_posts)
  puts "  #{Like.count} likes crees"

  # 8. Messages
  puts "Creation des messages..."
  seed_messages(all_users, all_projects)
  puts "  #{Message.count} messages crees"

  # Summary
  puts ""
  puts "=" * 60
  puts "SEED DEVELOPMENT TERMINEE !"
  puts "=" * 60
  puts "Utilisateurs        : #{User.count}"
  puts "Skills              : #{Skill.count}"
  puts "Projets             : #{Project.count}"
  puts "Teams               : #{Team.count}"
  puts "Posts               : #{Post.count}"
  puts "Likes               : #{Like.count}"
  puts "Messages            : #{Message.count}"
  puts "=" * 60
  puts ""
  puts "Connexion test: greg@nexp.dev / azerty"
  puts "=" * 60
end

def seed_users(all_skills, all_badges)
  users_data = [
    # Compte principal
    {
      email: "greg@nexp.dev",
      password: "azerty",
      name: "Gregory Lefebvre",
      username: "greegs0",
      bio: "Founder @NexP | Full-Stack Ruby on Rails Developer | Passionne par l'automatisation et l'optimisation.",
      zipcode: "75001",
      github_url: "https://github.com/greegs0",
      linkedin_url: "https://linkedin.com/in/gregory-lefebvre",
      portfolio_url: "https://gregory-lefebvre.dev",
      experience_points: 5000,
      level: 12,
      available: true,
      skills: ["Ruby on Rails", "PostgreSQL", "JavaScript", "React", "Docker", "Git", "AWS", "Redis", "Stimulus", "Tailwind CSS"]
    },
    {
      email: "sarah.martin@gmail.com",
      password: "password123",
      name: "Sarah Martin",
      username: "sarahdev",
      bio: "Full-Stack Developer | React & Node.js enthusiast | Remote work advocate",
      zipcode: "69001",
      github_url: "https://github.com/sarahdev",
      linkedin_url: "https://linkedin.com/in/sarah-martin",
      experience_points: 3200,
      level: 9,
      available: true,
      skills: ["React", "Node.js", "TypeScript", "MongoDB", "Express.js", "Next.js", "Tailwind CSS", "Git", "Docker", "AWS"]
    },
    {
      email: "thomas.dubois@outlook.fr",
      password: "password123",
      name: "Thomas Dubois",
      username: "thomasdev",
      bio: "Developpeur Full-Stack | Python & Django | Passionne de clean code",
      zipcode: "33000",
      github_url: "https://github.com/thomasdev",
      linkedin_url: "https://linkedin.com/in/thomas-dubois",
      experience_points: 2800,
      level: 8,
      available: true,
      skills: ["Python", "Django", "PostgreSQL", "React", "Docker", "Git", "API REST", "Redis", "Celery", "Linux"]
    },
    {
      email: "emma.rousseau@protonmail.com",
      password: "password123",
      name: "Emma Rousseau",
      username: "emmacode",
      bio: "Senior Full-Stack Engineer | Vue.js & Laravel | Tech lead | Mentor",
      zipcode: "44000",
      github_url: "https://github.com/emmacode",
      linkedin_url: "https://linkedin.com/in/emma-rousseau",
      portfolio_url: "https://emma-rousseau.dev",
      experience_points: 4500,
      level: 11,
      available: false,
      skills: ["Vue.js", "Laravel", "PHP", "MySQL", "Nuxt.js", "Tailwind CSS", "Git", "Docker", "CI/CD", "Nginx"]
    },
    {
      email: "lucas.bernard@gmail.com",
      password: "password123",
      name: "Lucas Bernard",
      username: "lucasback",
      bio: "Backend Engineer | Node.js & Microservices | Performance optimization geek",
      zipcode: "59000",
      github_url: "https://github.com/lucasback",
      linkedin_url: "https://linkedin.com/in/lucas-bernard",
      experience_points: 3600,
      level: 10,
      available: true,
      skills: ["Node.js", "Express.js", "PostgreSQL", "Redis", "RabbitMQ", "Docker", "Kubernetes", "Microservices", "AWS", "GraphQL"]
    },
    {
      email: "antoine.moreau@yahoo.fr",
      password: "password123",
      name: "Antoine Moreau",
      username: "antoineapi",
      bio: "API Architect | Go & Rust | Building high-performance systems",
      zipcode: "31000",
      github_url: "https://github.com/antoineapi",
      experience_points: 4000,
      level: 10,
      available: true,
      skills: ["Go", "Rust", "PostgreSQL", "Redis", "gRPC", "Docker", "Kubernetes", "Terraform", "Microservices", "API REST"]
    },
    {
      email: "julie.petit@gmail.com",
      password: "password123",
      name: "Julie Petit",
      username: "juliefront",
      bio: "Frontend Developer | React & TypeScript | UI perfectionist | Accessibility advocate",
      zipcode: "13001",
      github_url: "https://github.com/juliefront",
      linkedin_url: "https://linkedin.com/in/julie-petit",
      portfolio_url: "https://julie-petit.com",
      experience_points: 2600,
      level: 8,
      available: true,
      skills: ["React", "TypeScript", "Next.js", "Tailwind CSS", "Styled Components", "Webpack", "Jest", "Cypress", "Accessibility Design", "Responsive Design"]
    },
    {
      email: "maxime.leroy@gmail.com",
      password: "password123",
      name: "Maxime Leroy",
      username: "maximefront",
      bio: "Creative Frontend Developer | Vue.js wizard | Animation enthusiast",
      zipcode: "67000",
      github_url: "https://github.com/maximefront",
      experience_points: 2200,
      level: 7,
      available: true,
      skills: ["Vue.js", "Nuxt.js", "JavaScript", "CSS", "SASS", "Animation", "Vite", "Pinia", "Tailwind CSS", "Figma"]
    },
    {
      email: "camille.garcia@gmail.com",
      password: "password123",
      name: "Camille Garcia",
      username: "camilledesign",
      bio: "UI/UX Designer | Product designer | Figma expert | Design systems enthusiast",
      zipcode: "75011",
      github_url: "https://github.com/camilledesign",
      linkedin_url: "https://linkedin.com/in/camille-garcia",
      portfolio_url: "https://camille-garcia.design",
      experience_points: 3400,
      level: 9,
      available: true,
      skills: ["UI/UX Design", "Figma", "Prototyping", "Design Systems", "User Research", "Wireframing", "Adobe XD", "Design Thinking", "User Testing", "Accessibility Design"]
    },
    {
      email: "lea.roux@gmail.com",
      password: "password123",
      name: "Lea Roux",
      username: "learoux",
      bio: "Product Designer | Motion Design | Brand identity",
      zipcode: "69002",
      github_url: "https://github.com/learoux",
      portfolio_url: "https://lea-roux.design",
      experience_points: 2900,
      level: 8,
      available: true,
      skills: ["UI/UX Design", "Figma", "Motion Design", "After Effects", "Brand Design", "Prototyping", "Illustrator", "Design Systems", "Animation"]
    },
    {
      email: "nicolas.blanc@gmail.com",
      password: "password123",
      name: "Nicolas Blanc",
      username: "nicolasmobile",
      bio: "Mobile Developer | React Native & Flutter | Cross-platform expert",
      zipcode: "06000",
      github_url: "https://github.com/nicolasmobile",
      linkedin_url: "https://linkedin.com/in/nicolas-blanc",
      experience_points: 3800,
      level: 10,
      available: true,
      skills: ["React Native", "Flutter", "TypeScript", "Dart", "iOS Development", "Android Development", "Expo", "Firebase", "Redux", "Mobile First"]
    },
    {
      email: "chloe.fontaine@gmail.com",
      password: "password123",
      name: "Chloe Fontaine",
      username: "chloeiOS",
      bio: "iOS Developer | Swift & SwiftUI | Apple ecosystem lover",
      zipcode: "75015",
      github_url: "https://github.com/chloeiOS",
      experience_points: 2400,
      level: 7,
      available: true,
      skills: ["Swift", "SwiftUI", "iOS Development", "Xcode", "Core Data", "Combine", "UIKit", "Git"]
    },
    {
      email: "pierre.lambert@gmail.com",
      password: "password123",
      name: "Pierre Lambert",
      username: "pierreai",
      bio: "AI/ML Engineer | PhD in Computer Science | RAG & LLM specialist",
      zipcode: "75005",
      github_url: "https://github.com/pierreai",
      linkedin_url: "https://linkedin.com/in/pierre-lambert",
      portfolio_url: "https://pierre-lambert.ai",
      experience_points: 5200,
      level: 13,
      available: true,
      skills: ["Python", "TensorFlow", "PyTorch", "Machine Learning", "Deep Learning", "NLP", "RAG", "LangChain", "OpenAI", "Prompt Engineering", "Data Analysis"]
    },
    {
      email: "sophie.mercier@gmail.com",
      password: "password123",
      name: "Sophie Mercier",
      username: "sophiedata",
      bio: "Data Scientist | ML Engineer | Kaggle Master",
      zipcode: "31000",
      github_url: "https://github.com/sophiedata",
      linkedin_url: "https://linkedin.com/in/sophie-mercier",
      experience_points: 4200,
      level: 11,
      available: true,
      skills: ["Python", "Machine Learning", "Data Analysis", "Pandas", "NumPy", "scikit-learn", "TensorFlow", "Jupyter", "SQL", "Data Visualization"]
    },
    {
      email: "alexandre.bonnet@gmail.com",
      password: "password123",
      name: "Alexandre Bonnet",
      username: "alexdevops",
      bio: "DevOps Engineer | Kubernetes & Terraform | Cloud architecture",
      zipcode: "69003",
      github_url: "https://github.com/alexdevops",
      linkedin_url: "https://linkedin.com/in/alexandre-bonnet",
      experience_points: 4600,
      level: 11,
      available: true,
      skills: ["Kubernetes", "Docker", "Terraform", "AWS", "GitLab CI", "Ansible", "Linux", "Bash", "Monitoring", "Nginx"]
    },
    {
      email: "marie.laurent@gmail.com",
      password: "password123",
      name: "Marie Laurent",
      username: "mariepm",
      bio: "Product Manager | Agile Coach | Data-driven decision maker",
      zipcode: "75008",
      linkedin_url: "https://linkedin.com/in/marie-laurent",
      experience_points: 3000,
      level: 9,
      available: true,
      skills: ["Product Management", "Agile", "Scrum", "Jira", "User Stories", "Product Strategy", "Analytics", "A/B Testing", "Roadmapping"]
    },
    {
      email: "hugo.vincent@gmail.com",
      password: "password123",
      name: "Hugo Vincent",
      username: "hugodev",
      bio: "Junior Full-Stack Developer | Fresh bootcamp graduate | Ready to learn",
      zipcode: "44000",
      github_url: "https://github.com/hugodev",
      experience_points: 500,
      level: 3,
      available: true,
      skills: ["HTML", "CSS", "JavaScript", "React", "Node.js", "Git", "MongoDB", "Express.js"]
    },
    {
      email: "clara.girard@gmail.com",
      password: "password123",
      name: "Clara Girard",
      username: "claradesign",
      bio: "Aspiring UX Designer | Design student | Passionate about interfaces",
      zipcode: "33000",
      portfolio_url: "https://clara-girard.com",
      experience_points: 400,
      level: 2,
      available: true,
      skills: ["UI/UX Design", "Figma", "Wireframing", "Prototyping", "User Research"]
    },
    {
      email: "david.morel@gmail.com",
      password: "password123",
      name: "David Morel",
      username: "davidfreelance",
      bio: "Freelance Full-Stack | 10+ years experience | Building MVPs & scaling startups",
      zipcode: "13002",
      github_url: "https://github.com/davidfreelance",
      linkedin_url: "https://linkedin.com/in/david-morel",
      portfolio_url: "https://david-morel.com",
      experience_points: 6000,
      level: 15,
      available: false,
      skills: ["Ruby on Rails", "React", "PostgreSQL", "Redis", "Docker", "AWS", "Heroku", "Git", "CI/CD", "Agile"]
    },
    {
      email: "mathieu.durand@gmail.com",
      password: "password123",
      name: "Mathieu Durand",
      username: "mathieuweb3",
      bio: "Blockchain Developer | Solidity & Web3 | Smart contracts specialist",
      zipcode: "75009",
      github_url: "https://github.com/mathieuweb3",
      linkedin_url: "https://linkedin.com/in/mathieu-durand",
      experience_points: 3300,
      level: 9,
      available: true,
      skills: ["Solidity", "Web3.js", "Ethers.js", "Smart Contracts", "Ethereum", "React", "Node.js", "TypeScript"]
    },
    {
      email: "valentin.simon@gmail.com",
      password: "password123",
      name: "Valentin Simon",
      username: "valentingame",
      bio: "Game Developer | Unity & Unreal Engine | 3D Graphics",
      zipcode: "69006",
      github_url: "https://github.com/valentingame",
      portfolio_url: "https://valentin-simon.games",
      experience_points: 2700,
      level: 8,
      available: true,
      skills: ["Unity", "C#", "3D Graphics", "Game Design", "Shaders", "Physics", "Blender"]
    },
    {
      email: "yasmine.benali@gmail.com",
      password: "password123",
      name: "Yasmine Benali",
      username: "yasminedev",
      bio: "Full-Stack Engineer | Rust enthusiast | Performance optimization",
      zipcode: "59000",
      github_url: "https://github.com/yasminedev",
      linkedin_url: "https://linkedin.com/in/yasmine-benali",
      experience_points: 4100,
      level: 10,
      available: true,
      skills: ["Rust", "WebAssembly", "Go", "PostgreSQL", "Docker", "Kubernetes", "Performance Optimization"]
    },
    {
      email: "baptiste.mercier@protonmail.com",
      password: "password123",
      name: "Baptiste Mercier",
      username: "baptistemobile",
      bio: "Flutter Expert | Published 30+ apps | Tech speaker",
      zipcode: "35000",
      github_url: "https://github.com/baptistemobile",
      linkedin_url: "https://linkedin.com/in/baptiste-mercier",
      portfolio_url: "https://baptiste-mercier.dev",
      experience_points: 3700,
      level: 10,
      available: true,
      skills: ["Flutter", "Dart", "Firebase", "iOS Development", "Android Development", "Cross-Platform", "Mobile First"]
    },
    {
      email: "oceane.dubois@gmail.com",
      password: "password123",
      name: "Oceane Dubois",
      username: "oceanedesign",
      bio: "Motion Designer | After Effects wizard | Creating smooth animations",
      zipcode: "13003",
      github_url: "https://github.com/oceanedesign",
      portfolio_url: "https://oceane-dubois.com",
      experience_points: 2500,
      level: 7,
      available: true,
      skills: ["Motion Design", "After Effects", "Animation", "Brand Design", "Illustrator", "Figma"]
    },
    {
      email: "romain.faure@gmail.com",
      password: "password123",
      name: "Romain Faure",
      username: "romaincloud",
      bio: "Cloud Architect | AWS Certified | Multi-cloud expert",
      zipcode: "31000",
      github_url: "https://github.com/romaincloud",
      linkedin_url: "https://linkedin.com/in/romain-faure",
      experience_points: 5500,
      level: 13,
      available: false,
      skills: ["AWS", "GCP", "Azure", "Terraform", "Kubernetes", "Docker", "CloudFormation", "Pulumi", "Monitoring"]
    },
    {
      email: "laura.martinez@gmail.com",
      password: "password123",
      name: "Laura Martinez",
      username: "lauradata",
      bio: "Data Engineer | Building data pipelines | Apache Spark expert",
      zipcode: "67000",
      github_url: "https://github.com/lauradata",
      linkedin_url: "https://linkedin.com/in/laura-martinez",
      experience_points: 3900,
      level: 10,
      available: true,
      skills: ["Python", "Apache Spark", "SQL", "Data Analysis", "PostgreSQL", "MongoDB", "Data Visualization", "Pandas"]
    },
    {
      email: "kevin.roussel@gmail.com",
      password: "password123",
      name: "Kevin Roussel",
      username: "kevinfullstack",
      bio: "Full-Stack Architect | Next.js & tRPC | TypeScript fanatic",
      zipcode: "44000",
      github_url: "https://github.com/kevinfullstack",
      linkedin_url: "https://linkedin.com/in/kevin-roussel",
      portfolio_url: "https://kevin-roussel.dev",
      experience_points: 4400,
      level: 11,
      available: true,
      skills: ["TypeScript", "Next.js", "tRPC", "Prisma", "PostgreSQL", "React", "Tailwind CSS", "Vercel"]
    },
    {
      email: "agathe.robin@gmail.com",
      password: "password123",
      name: "Agathe Robin",
      username: "agatheux",
      bio: "Senior UX Researcher | User-centered design advocate",
      zipcode: "75010",
      linkedin_url: "https://linkedin.com/in/agathe-robin",
      portfolio_url: "https://agathe-robin.design",
      experience_points: 3300,
      level: 9,
      available: true,
      skills: ["UI/UX Design", "User Research", "User Testing", "Figma", "Wireframing", "Design Thinking", "Analytics"]
    },
    {
      email: "mehdi.hassan@gmail.com",
      password: "password123",
      name: "Mehdi Hassan",
      username: "mehdisecurity",
      bio: "Security Engineer | Ethical hacker | OSCP certified",
      zipcode: "69001",
      github_url: "https://github.com/mehdisecurity",
      linkedin_url: "https://linkedin.com/in/mehdi-hassan",
      experience_points: 4800,
      level: 12,
      available: true,
      skills: ["Web Security", "Penetration Testing", "OWASP", "Security Audits", "OAuth", "API Security", "Encryption"]
    },
    {
      email: "elise.bernard@gmail.com",
      password: "password123",
      name: "Elise Bernard",
      username: "elisefront",
      bio: "Frontend Engineer | Accessibility expert | Making the web inclusive",
      zipcode: "33000",
      github_url: "https://github.com/elisefront",
      linkedin_url: "https://linkedin.com/in/elise-bernard",
      experience_points: 3100,
      level: 9,
      available: true,
      skills: ["React", "TypeScript", "Accessibility Design", "Accessibility", "HTML", "CSS", "Responsive Design"]
    },
    {
      email: "theo.lambert@gmail.com",
      password: "password123",
      name: "Theo Lambert",
      username: "theoelixir",
      bio: "Elixir/Phoenix Developer | Functional programming lover | Real-time systems",
      zipcode: "59000",
      github_url: "https://github.com/theoelixir",
      linkedin_url: "https://linkedin.com/in/theo-lambert",
      experience_points: 3600,
      level: 10,
      available: true,
      skills: ["Elixir", "Phoenix", "PostgreSQL", "WebSockets", "Real-time Apps"]
    },
    {
      email: "pauline.girard@gmail.com",
      password: "password123",
      name: "Pauline Girard",
      username: "paulineqa",
      bio: "QA Engineer | Test automation specialist | Cypress & Playwright expert",
      zipcode: "06000",
      github_url: "https://github.com/paulineqa",
      linkedin_url: "https://linkedin.com/in/pauline-girard",
      experience_points: 2900,
      level: 8,
      available: true,
      skills: ["Cypress", "Playwright", "Jest", "Test-Driven Development", "QA Automation", "E2E Testing", "Bug Tracking"]
    },
    {
      email: "jeremy.morel@gmail.com",
      password: "password123",
      name: "Jeremy Morel",
      username: "jeremyiot",
      bio: "IoT Engineer | Arduino & Raspberry Pi | Edge computing",
      zipcode: "31000",
      github_url: "https://github.com/jeremyiot",
      experience_points: 2800,
      level: 8,
      available: true,
      skills: ["IoT", "Arduino", "Raspberry Pi", "Python", "C++", "MQTT", "Edge Computing"]
    },
    {
      email: "alice.fontaine@gmail.com",
      password: "password123",
      name: "Alice Fontaine",
      username: "alicepm",
      bio: "Technical Product Manager | Ex-developer turned PM | User-focused roadmaps",
      zipcode: "75002",
      linkedin_url: "https://linkedin.com/in/alice-fontaine",
      experience_points: 4200,
      level: 11,
      available: false,
      skills: ["Product Management", "Agile", "Scrum", "User Stories", "Roadmapping", "Analytics", "Technical Writing"]
    },
    {
      email: "yann.dupont@gmail.com",
      password: "password123",
      name: "Yann Dupont",
      username: "yannjunior",
      bio: "Junior Backend Developer | Python learner | Looking for mentorship",
      zipcode: "35000",
      github_url: "https://github.com/yannjunior",
      experience_points: 600,
      level: 3,
      available: true,
      skills: ["Python", "FastAPI", "PostgreSQL", "Git", "Docker", "API REST"]
    },
    {
      email: "sarah.leclerc@gmail.com",
      password: "password123",
      name: "Sarah Leclerc",
      username: "sarahastro",
      bio: "Frontend Developer | Astro enthusiast | SSG/SSR optimization | Performance-first",
      zipcode: "44000",
      github_url: "https://github.com/sarahastro",
      experience_points: 2300,
      level: 7,
      available: true,
      skills: ["Astro", "React", "TypeScript", "Tailwind CSS", "Performance Optimization", "SEO"]
    }
  ]

  all_users = []
  users_data.each do |user_data|
    skills = user_data.delete(:skills)

    user = User.create!(
      email: user_data[:email],
      password: user_data[:password],
      password_confirmation: user_data[:password],
      name: user_data[:name],
      username: user_data[:username],
      bio: user_data[:bio],
      zipcode: user_data[:zipcode],
      github_url: user_data[:github_url],
      linkedin_url: user_data[:linkedin_url],
      portfolio_url: user_data[:portfolio_url],
      experience_points: user_data[:experience_points] || 0,
      level: user_data[:level] || 1,
      available: user_data[:available],
      confirmed_at: Time.current
    )

    # Associate skills
    if skills
      skills.each do |skill_name|
        if all_skills[skill_name]
          UserSkill.create!(user: user, skill: all_skills[skill_name])
        end
      end
    end

    # Assign badges based on level
    assign_badges(user, skills, all_badges)

    all_users << user
  end

  all_users
end

def assign_badges(user, skills, all_badges)
  case user.level
  when 2..4
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 1.month.ago)
  when 5..7
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 3.months.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 2.months.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 1.month.ago)
  when 8..10
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 6.months.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 4.months.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 2.months.ago)
    UserBadge.create!(user: user, badge: all_badges[3], earned_at: 1.month.ago)
    if skills&.include?("React") || skills&.include?("Vue.js") || skills&.include?("Angular")
      UserBadge.create!(user: user, badge: all_badges[6], earned_at: 3.months.ago)
    end
    if skills&.include?("UI/UX Design") || skills&.include?("Figma")
      UserBadge.create!(user: user, badge: all_badges[7], earned_at: 3.months.ago)
    end
  when 11..12
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 1.year.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 10.months.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 6.months.ago)
    UserBadge.create!(user: user, badge: all_badges[3], earned_at: 4.months.ago)
    UserBadge.create!(user: user, badge: all_badges[4], earned_at: 2.months.ago)
    if skills&.include?("Ruby on Rails") || skills&.include?("React") || skills&.include?("Python")
      UserBadge.create!(user: user, badge: all_badges[6], earned_at: 5.months.ago)
    end
    UserBadge.create!(user: user, badge: all_badges[9], earned_at: 3.months.ago)
  when 13..20
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 2.years.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 1.year.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 10.months.ago)
    UserBadge.create!(user: user, badge: all_badges[3], earned_at: 8.months.ago)
    UserBadge.create!(user: user, badge: all_badges[4], earned_at: 6.months.ago)
    UserBadge.create!(user: user, badge: all_badges[5], earned_at: 4.months.ago)
    if skills&.include?("Machine Learning") || skills&.include?("RAG") || skills&.include?("OpenAI")
      UserBadge.create!(user: user, badge: all_badges[8], earned_at: 7.months.ago)
    end
    UserBadge.create!(user: user, badge: all_badges[9], earned_at: 5.months.ago)
  end
end

def seed_projects(all_users, all_skills)
  projects_data = [
    {
      owner: all_users[0],
      title: "NexP - Plateforme de Collaboration",
      description: "Plateforme web pour connecter des developpeurs, designers et entrepreneurs.",
      status: "in_progress",
      max_members: 6,
      start_date: 2.months.ago,
      deadline: 3.months.from_now,
      skills: ["Ruby on Rails", "PostgreSQL", "JavaScript", "Stimulus", "Tailwind CSS", "Redis", "Docker", "Git"]
    },
    {
      owner: all_users[1],
      title: "TaskFlow - Gestionnaire de Taches Collaboratif",
      description: "Application de gestion de taches moderne avec collaboration en temps reel.",
      status: "in_progress",
      max_members: 4,
      start_date: 1.month.ago,
      deadline: 2.months.from_now,
      skills: ["React", "Node.js", "MongoDB", "TypeScript", "Redux", "Material UI"]
    },
    {
      owner: all_users[2],
      title: "BlogHub - Plateforme de Blogging",
      description: "Plateforme de blogging moderne avec markdown et SEO optimise.",
      status: "open",
      max_members: 3,
      start_date: 2.weeks.ago,
      deadline: 4.months.from_now,
      skills: ["Django", "PostgreSQL", "React", "Celery", "Redis", "SEO"]
    },
    {
      owner: all_users[3],
      title: "EcoTrack - Calculateur d'Empreinte Carbone",
      description: "Application web pour calculer et suivre son empreinte carbone.",
      status: "completed",
      max_members: 4,
      start_date: 4.months.ago,
      end_date: 1.month.ago,
      skills: ["Vue.js", "Laravel", "MySQL", "Nuxt.js", "Tailwind CSS"]
    },
    {
      owner: all_users[10],
      title: "FitBuddy - Coach Sportif Personnel",
      description: "Application mobile de coaching sportif avec IA.",
      status: "in_progress",
      max_members: 5,
      start_date: 3.weeks.ago,
      deadline: 5.months.from_now,
      skills: ["React Native", "Firebase", "TypeScript", "TensorFlow", "Expo", "Redux"]
    },
    {
      owner: all_users[11],
      title: "MindfulMe - Meditation & Bien-etre",
      description: "App iOS de meditation guidee avec contenu personnalise.",
      status: "open",
      max_members: 3,
      start_date: 1.week.ago,
      deadline: 3.months.from_now,
      skills: ["Swift", "SwiftUI", "iOS Development", "Core Data", "Animation"]
    },
    {
      owner: all_users[12],
      title: "DocuMind - Assistant IA pour Documents",
      description: "Assistant IA intelligent pour analyser et interroger vos documents.",
      status: "in_progress",
      max_members: 4,
      start_date: 1.month.ago,
      deadline: 4.months.from_now,
      skills: ["Python", "RAG", "LangChain", "OpenAI", "FastAPI", "PostgreSQL", "Vector Databases"]
    },
    {
      owner: all_users[13],
      title: "PredictStock - ML pour Prediction Boursiere",
      description: "Systeme de machine learning pour analyser les tendances boursieres.",
      status: "open",
      max_members: 3,
      start_date: 2.days.ago,
      deadline: 6.months.from_now,
      skills: ["Python", "Machine Learning", "TensorFlow", "Data Analysis", "Pandas", "PostgreSQL"]
    },
    {
      owner: all_users[4],
      title: "LocalMarket - Marketplace Local",
      description: "Marketplace pour produits locaux avec livraison integree.",
      status: "in_progress",
      max_members: 8,
      start_date: 2.months.ago,
      deadline: 6.months.from_now,
      skills: ["Node.js", "React", "React Native", "PostgreSQL", "Redis", "Microservices", "Stripe"]
    },
    {
      owner: all_users[5],
      title: "CodeReview.ai - Review de Code par IA",
      description: "SaaS de review automatique de code avec suggestions IA.",
      status: "in_progress",
      max_members: 5,
      start_date: 3.weeks.ago,
      deadline: 5.months.from_now,
      skills: ["Go", "PostgreSQL", "OpenAI", "React", "Kubernetes", "Docker", "Git"]
    },
    {
      owner: all_users[8],
      title: "DesignSystem Pro - Generateur de Design Systems",
      description: "Outil en ligne pour creer des design systems complets.",
      status: "open",
      max_members: 4,
      skills: ["React", "TypeScript", "Figma", "Design Systems", "Storybook", "UI/UX Design"]
    },
    {
      owner: all_users[14],
      title: "DeployMaster - Plateforme de Deploiement",
      description: "Alternative open-source a Vercel/Netlify.",
      status: "in_progress",
      max_members: 6,
      start_date: 1.month.ago,
      deadline: 8.months.from_now,
      skills: ["Kubernetes", "Docker", "Terraform", "Go", "React", "PostgreSQL", "CI/CD"]
    },
    {
      owner: all_users[15],
      title: "SkillShare - Echange de Competences",
      description: "Plateforme d'echange de competences peer-to-peer.",
      status: "open",
      max_members: 5,
      deadline: 4.months.from_now,
      skills: ["Ruby on Rails", "PostgreSQL", "React", "WebRTC", "Redis"]
    },
    {
      owner: all_users[19],
      title: "NFTGallery - Galerie NFT Communautaire",
      description: "Plateforme decentralisee pour creer et vendre des NFTs.",
      status: "in_progress",
      max_members: 4,
      start_date: 3.weeks.ago,
      deadline: 5.months.from_now,
      skills: ["Solidity", "Web3.js", "Ethers.js", "React", "Smart Contracts", "IPFS"]
    },
    {
      owner: all_users[20],
      title: "PixelQuest - RPG 2D Multijoueur",
      description: "Jeu RPG 2D en ligne inspire de Stardew Valley.",
      status: "in_progress",
      max_members: 10,
      start_date: 2.months.ago,
      deadline: 1.year.from_now,
      skills: ["Unity", "C#", "Game Design", "Multiplayer", "3D Graphics", "Photoshop"]
    },
    {
      owner: all_users[16],
      title: "QuizApp - Application de Quiz Interactifs",
      description: "Application web simple pour creer et partager des quiz.",
      status: "open",
      max_members: 3,
      deadline: 2.months.from_now,
      skills: ["React", "Node.js", "MongoDB", "HTML", "CSS", "JavaScript"]
    },
    {
      owner: all_users[17],
      title: "PortfolioBuilder - Generateur de Portfolios",
      description: "Outil no-code pour creer son portfolio.",
      status: "open",
      max_members: 2,
      deadline: 3.months.from_now,
      skills: ["Vue.js", "Firebase", "UI/UX Design", "Figma"]
    },
    {
      owner: all_users[18],
      title: "WeatherNow - API Meteo Avancee",
      description: "API REST pour donnees meteo avec predictions ML.",
      status: "completed",
      max_members: 3,
      start_date: 6.months.ago,
      end_date: 2.months.ago,
      skills: ["Python", "FastAPI", "Machine Learning", "PostgreSQL", "Redis"]
    },
    {
      owner: all_users[6],
      title: "AnimateCSS Pro - Bibliotheque d'Animations",
      description: "Collection d'animations CSS modernes et performantes.",
      status: "completed",
      max_members: 2,
      start_date: 4.months.ago,
      end_date: 1.month.ago,
      skills: ["CSS", "JavaScript", "Animation", "Responsive Design"]
    },
    {
      owner: all_users[7],
      title: "SmartHome Dashboard",
      description: "Dashboard centralise pour domotique.",
      status: "in_progress",
      max_members: 4,
      start_date: 2.weeks.ago,
      deadline: 4.months.from_now,
      skills: ["Vue.js", "Node.js", "IoT", "MQTT", "WebSockets", "Tailwind CSS"]
    },
    {
      owner: all_users[21],
      title: "RustCache - Systeme de Cache Distribue",
      description: "Cache distribue haute performance ecrit en Rust.",
      status: "in_progress",
      max_members: 4,
      start_date: 3.weeks.ago,
      deadline: 5.months.from_now,
      skills: ["Rust", "WebAssembly", "Performance Optimization", "Docker", "Kubernetes"]
    },
    {
      owner: all_users[22],
      title: "TravelMate - Guide de Voyage Communautaire",
      description: "App mobile pour decouvrir et partager des lieux de voyage.",
      status: "in_progress",
      max_members: 5,
      start_date: 1.month.ago,
      deadline: 4.months.from_now,
      skills: ["Flutter", "Dart", "Firebase", "Mobile First"]
    },
    {
      owner: all_users[24],
      title: "CloudCost - Optimiseur de Couts Cloud",
      description: "SaaS pour analyser et optimiser les depenses cloud.",
      status: "in_progress",
      max_members: 6,
      start_date: 2.months.ago,
      deadline: 6.months.from_now,
      skills: ["AWS", "GCP", "Azure", "Terraform", "Go", "React", "PostgreSQL", "Kubernetes"]
    },
    {
      owner: all_users[25],
      title: "DataFlow - Plateforme ETL No-Code",
      description: "Plateforme visuelle pour creer des pipelines de donnees.",
      status: "open",
      max_members: 5,
      deadline: 7.months.from_now,
      skills: ["Python", "Apache Spark", "React", "PostgreSQL", "Data Analysis"]
    },
    {
      owner: all_users[26],
      title: "FormCraft - Generateur de Formulaires Intelligents",
      description: "Creer des formulaires dynamiques avec validation.",
      status: "in_progress",
      max_members: 4,
      start_date: 2.weeks.ago,
      deadline: 4.months.from_now,
      skills: ["Next.js", "tRPC", "TypeScript", "Prisma", "PostgreSQL", "React"]
    },
    {
      owner: all_users[27],
      title: "UserLab - Plateforme de Tests Utilisateurs",
      description: "Recrutement et gestion de tests utilisateurs a distance.",
      status: "open",
      max_members: 4,
      deadline: 5.months.from_now,
      skills: ["Vue.js", "Laravel", "PostgreSQL", "User Research", "Analytics", "WebRTC"]
    },
    {
      owner: all_users[28],
      title: "SecureCheck - Scanner de Vulnerabilites",
      description: "Outil automatise pour scanner les vulnerabilites web.",
      status: "in_progress",
      max_members: 4,
      start_date: 1.month.ago,
      deadline: 5.months.from_now,
      skills: ["Python", "Go", "Web Security", "OWASP", "Penetration Testing", "Docker"]
    },
    {
      owner: all_users[29],
      title: "A11yKit - Bibliotheque de Composants Accessibles",
      description: "Composants React accessibles (WCAG AAA) prets a l'emploi.",
      status: "open",
      max_members: 3,
      deadline: 4.months.from_now,
      skills: ["React", "TypeScript", "Accessibility Design", "Accessibility", "Storybook", "Jest"]
    },
    {
      owner: all_users[30],
      title: "ChatStream - Plateforme de Chat Temps Reel",
      description: "Infrastructure de chat scalable avec Phoenix Channels.",
      status: "in_progress",
      max_members: 4,
      start_date: 3.weeks.ago,
      deadline: 5.months.from_now,
      skills: ["Elixir", "Phoenix", "PostgreSQL", "Real-time Apps", "WebSockets", "React"]
    },
    {
      owner: all_users[31],
      title: "TestMaster - Plateforme de Test Management",
      description: "Gestion centralisee des tests et de la qualite logicielle.",
      status: "open",
      max_members: 3,
      deadline: 4.months.from_now,
      skills: ["React", "Node.js", "PostgreSQL", "Cypress", "QA Automation", "Jest"]
    },
    {
      owner: all_users[32],
      title: "SmartGarden - Jardin Connecte",
      description: "Systeme IoT pour automatiser l'entretien de son jardin.",
      status: "in_progress",
      max_members: 4,
      start_date: 2.weeks.ago,
      deadline: 4.months.from_now,
      skills: ["IoT", "Arduino", "Raspberry Pi", "Python", "MQTT", "React Native"]
    },
    {
      owner: all_users[34],
      title: "RecipeBox - Application de Recettes",
      description: "App simple pour gerer ses recettes de cuisine.",
      status: "open",
      max_members: 3,
      deadline: 3.months.from_now,
      skills: ["Python", "FastAPI", "React", "PostgreSQL", "API REST"]
    },
    {
      owner: all_users[35],
      title: "TechBlog - Blog Technique Performant",
      description: "Blog technique avec Astro pour des performances optimales.",
      status: "in_progress",
      max_members: 2,
      start_date: 1.week.ago,
      deadline: 2.months.from_now,
      skills: ["Astro", "React", "TypeScript", "Tailwind CSS", "SEO", "Performance Optimization"]
    },
    {
      owner: all_users[11],
      title: "NotesApp - Application de Notes",
      description: "App iOS native pour prendre des notes avec markdown.",
      status: "completed",
      max_members: 2,
      start_date: 5.months.ago,
      end_date: 2.months.ago,
      skills: ["Swift", "SwiftUI", "iOS Development", "Core Data"]
    },
    {
      owner: all_users[23],
      title: "BrandKit - Kit de Marque Automatise",
      description: "Generateur automatique de brand kits pour startups.",
      status: "completed",
      max_members: 3,
      start_date: 8.months.ago,
      end_date: 4.months.ago,
      skills: ["Brand Design", "Motion Design", "Figma", "After Effects"]
    },
    {
      owner: all_users[7],
      title: "AnimeDex - Base de donnees d'anime",
      description: "Application web pour decouvrir et suivre des animes.",
      status: "completed",
      max_members: 3,
      start_date: 7.months.ago,
      end_date: 3.months.ago,
      skills: ["Vue.js", "Nuxt.js", "PostgreSQL", "Tailwind CSS"]
    },
    {
      owner: all_users[9],
      title: "LogoAI - Generateur de Logos par IA",
      description: "Generateur de logos professionels avec IA.",
      status: "open",
      max_members: 3,
      deadline: 3.months.from_now,
      skills: ["React", "Python", "OpenAI", "UI/UX Design", "Brand Design"]
    }
  ]

  all_projects = []
  projects_data.each do |project_data|
    skills = project_data.delete(:skills)

    project = Project.create!(
      owner: project_data[:owner],
      title: project_data[:title],
      description: project_data[:description],
      status: project_data[:status],
      max_members: project_data[:max_members],
      start_date: project_data[:start_date],
      end_date: project_data[:end_date],
      deadline: project_data[:deadline]
    )

    if skills
      skills.each do |skill_name|
        if all_skills[skill_name]
          ProjectSkill.create!(project: project, skill: all_skills[skill_name])
        end
      end
    end

    all_projects << project
  end

  all_projects
end

def seed_teams(all_users, all_projects)
  teams_data = [
    { user: all_users[1], project: all_projects[0], role: "Frontend Developer", status: "accepted" },
    { user: all_users[8], project: all_projects[0], role: "UI/UX Designer", status: "accepted" },
    { user: all_users[14], project: all_projects[0], role: "DevOps Engineer", status: "accepted" },
    { user: all_users[4], project: all_projects[1], role: "Backend Developer", status: "accepted" },
    { user: all_users[6], project: all_projects[1], role: "Frontend Developer", status: "accepted" },
    { user: all_users[16], project: all_projects[2], role: "Junior Developer", status: "accepted" },
    { user: all_users[12], project: all_projects[4], role: "AI/ML Engineer", status: "accepted" },
    { user: all_users[9], project: all_projects[4], role: "UI/UX Designer", status: "accepted" },
    { user: all_users[13], project: all_projects[6], role: "Data Scientist", status: "accepted" },
    { user: all_users[5], project: all_projects[6], role: "Backend Engineer", status: "pending" },
    { user: all_users[1], project: all_projects[8], role: "Frontend Lead", status: "accepted" },
    { user: all_users[10], project: all_projects[8], role: "Mobile Developer", status: "accepted" },
    { user: all_users[8], project: all_projects[8], role: "Product Designer", status: "accepted" },
    { user: all_users[0], project: all_projects[9], role: "Technical Advisor", status: "accepted" },
    { user: all_users[6], project: all_projects[9], role: "Frontend Developer", status: "accepted" },
    { user: all_users[5], project: all_projects[11], role: "Backend Engineer", status: "accepted" },
    { user: all_users[7], project: all_projects[11], role: "Frontend Developer", status: "pending" },
    { user: all_users[1], project: all_projects[13], role: "Frontend Developer", status: "accepted" },
    { user: all_users[9], project: all_projects[14], role: "Game Designer", status: "accepted" },
    { user: all_users[17], project: all_projects[14], role: "UI Designer", status: "pending" },
    { user: all_users[4], project: all_projects[19], role: "Backend Developer", status: "accepted" },
    { user: all_users[5], project: all_projects[20], role: "Backend Engineer", status: "accepted" },
    { user: all_users[14], project: all_projects[20], role: "DevOps Engineer", status: "accepted" },
    { user: all_users[9], project: all_projects[21], role: "UI/UX Designer", status: "accepted" },
    { user: all_users[10], project: all_projects[21], role: "Mobile Developer", status: "pending" },
    { user: all_users[12], project: all_projects[21], role: "AI Engineer", status: "accepted" },
    { user: all_users[14], project: all_projects[22], role: "Infrastructure Lead", status: "accepted" },
    { user: all_users[5], project: all_projects[22], role: "Backend Developer", status: "accepted" },
    { user: all_users[6], project: all_projects[22], role: "Frontend Developer", status: "accepted" },
    { user: all_users[0], project: all_projects[22], role: "Technical Advisor", status: "accepted" },
    { user: all_users[13], project: all_projects[23], role: "Data Scientist", status: "pending" },
    { user: all_users[6], project: all_projects[24], role: "Frontend Developer", status: "accepted" },
    { user: all_users[8], project: all_projects[24], role: "Product Designer", status: "accepted" },
    { user: all_users[5], project: all_projects[26], role: "Backend Engineer", status: "accepted" },
    { user: all_users[31], project: all_projects[26], role: "QA Engineer", status: "accepted" },
    { user: all_users[4], project: all_projects[28], role: "Backend Developer", status: "accepted" },
    { user: all_users[1], project: all_projects[28], role: "Frontend Developer", status: "accepted" },
    { user: all_users[34], project: all_projects[30], role: "Junior Developer", status: "accepted" },
    { user: all_users[7], project: all_projects[30], role: "Frontend Developer", status: "accepted" },
    { user: all_users[16], project: all_projects[31], role: "Junior Developer", status: "accepted" },
    { user: all_users[2], project: all_projects[32], role: "Content Writer", status: "accepted" },
    { user: all_users[21], project: all_projects[9], role: "Performance Engineer", status: "accepted" },
    { user: all_users[26], project: all_projects[1], role: "Full-Stack Developer", status: "accepted" },
    { user: all_users[31], project: all_projects[9], role: "QA Lead", status: "accepted" },
    { user: all_users[35], project: all_projects[2], role: "Frontend Developer", status: "accepted" },
    { user: all_users[25], project: all_projects[6], role: "Data Engineer", status: "accepted" },
    { user: all_users[27], project: all_projects[8], role: "Product Designer", status: "accepted" },
    { user: all_users[32], project: all_projects[19], role: "IoT Engineer", status: "accepted" }
  ]

  teams_data.each do |team_data|
    team = Team.create!(
      user: team_data[:user],
      project: team_data[:project],
      role: team_data[:role],
      status: team_data[:status]
    )

    if team.status == "accepted"
      team.update!(joined_at: rand(1..30).days.ago)
    end
  end
end

def seed_posts(all_users)
  posts_content = [
    { user_idx: 0, content: "Super excite de lancer NexP ! Une plateforme pour connecter builders et creer des projets incroyables ensemble. #buildinpublic #startup" },
    { user_idx: 1, content: "Viens de terminer le redesign complet de TaskFlow ! Les animations sont ultra smooth maintenant. React + Framer Motion = <3 #frontend #react" },
    { user_idx: 12, content: "Apres 2 semaines de dev, notre systeme RAG atteint enfin 95% de precision sur les requetes complexes ! #AI #machinelearning" },
    { user_idx: 8, content: "Nouveau design system en cours pour un client ! J'adore creer des composants reutilisables et coherents. #design #figma" },
    { user_idx: 10, content: "50k telechargements sur notre app ! Merci a toute la communaute qui nous soutient. React Native FTW! #mobile #reactnative" },
    { user_idx: 14, content: "Migration vers Kubernetes terminee avec succes ! 99.99% uptime et deploiements 10x plus rapides. #devops #kubernetes" },
    { user_idx: 16, content: "Mon premier projet open-source ! C'est pas parfait mais je suis fier du chemin parcouru. Feedback welcome ! #junior #learning" },
    { user_idx: 19, content: "Notre smart contract est deploye sur mainnet ! Les NFTs mintent comme des petits pains. Web3 is here! #blockchain #web3" },
    { user_idx: 3, content: "Code review de la semaine : toujours preferer la composition a l'heritage ! Laravel rend ca tellement elegant. #php #cleancode" },
    { user_idx: 13, content: "Notre modele ML vient de battre le baseline de 15% ! Le features engineering c'est vraiment de l'art. #datascience #ml" },
    { user_idx: 15, content: "Sprint planning done ! L'equipe est super motivee pour les 2 prochaines semaines ! Agile > tout #productmanagement #agile" },
    { user_idx: 6, content: "TIL: CSS container queries changent vraiment la donne pour le responsive design. Plus besoin de media queries partout ! #css #frontend" },
    { user_idx: 2, content: "Django 5.0 est incroyable ! Les amelioration de performance sont bluffantes. Python reste le meilleur pour le backend. #python #django" },
    { user_idx: 20, content: "16 heures de dev aujourd'hui sur le systeme de combat... Unity c'est addictif ! #gamedev #unity" },
    { user_idx: 17, content: "Feedback sur mes maquettes = super positifs ! Je progresse chaque jour. #designer #learning" },
    { user_idx: 21, content: "Rust c'est vraiment incroyable pour la performance ! Notre cache distribue atteint 1M req/s avec 0 downtime. #rustlang #performance" },
    { user_idx: 22, content: "Viens de publier ma 31eme app sur les stores ! Flutter me permet d'etre hyper productif. #flutter #mobile" },
    { user_idx: 23, content: "Animation terminee pour un client apres 3 jours de travail. After Effects + creativite = magie. #motion #animation" },
    { user_idx: 24, content: "Multi-cloud c'est le futur ! AWS + GCP + Azure dans la meme infra. Terraform fait tout le boulot. #cloud #devops" },
    { user_idx: 25, content: "Pipeline de donnees qui traite 10TB par jour. Apache Spark est une vraie bete de course. #data #bigdata" },
    { user_idx: 26, content: "tRPC + Next.js = le combo parfait pour du full-stack typesafe. Plus jamais de bug de typage entre front et back! #typescript #nextjs" },
    { user_idx: 27, content: "5 sessions de tests utilisateurs cette semaine. Les insights sont incroyables ! #ux #research" },
    { user_idx: 28, content: "Trouve 12 vulnerabilites critiques aujourd'hui. La securite web c'est pas optionnel les amis. #security #bugbounty" },
    { user_idx: 29, content: "L'accessibilite c'est pour tout le monde ! Nos composants WCAG AAA sont enfin prets. Le web doit etre inclusif. #a11y #accessibility" },
    { user_idx: 30, content: "Phoenix Channels = 2 millions de connexions WebSocket simultanees sur un seul serveur. Elixir est magique. #elixir #realtime" },
    { user_idx: 31, content: "Cypress + Playwright = meilleur combo pour tester. Code coverage a 95% sur notre dernier projet. #testing #qa" },
    { user_idx: 32, content: "Mon jardin est maintenant automatique grace a l'IoT ! Arduino + capteurs + MQTT = bonheur. #iot #maker" },
    { user_idx: 34, content: "Mon premier bug fix accepte en open source ! Petit mais fier. #junior #opensource" },
    { user_idx: 35, content: "Astro + Tailwind = combo parfait pour un blog performant. Lighthouse score 100/100 sur toutes les metriques! #astro #performance" },
    { user_idx: 0, content: "Apres 6 mois de developpement, NexP atteint 1000 projets crees ! Merci a toute la communaute. #milestone #nexp" },
    { user_idx: 5, content: "Code review de la semaine : les microservices c'est bien, mais commencez par un monolithe bien architecture ! #architecture #golang" }
  ]

  all_posts = []
  posts_content.each do |post_data|
    post = Post.create!(
      user: all_users[post_data[:user_idx]],
      content: post_data[:content],
      created_at: rand(1..14).days.ago
    )
    all_posts << post
  end

  all_posts
end

def seed_likes(all_users, all_posts)
  all_posts.each do |post|
    max_likes = post.user.level > 10 ? 25 : (post.user.level > 5 ? 20 : 15)
    min_likes = post.user.level > 10 ? 10 : (post.user.level > 5 ? 5 : 3)

    likers = all_users.sample(rand(min_likes..max_likes))
    likers.each do |user|
      next if user == post.user

      begin
        Like.create!(user: user, post: post, created_at: post.created_at + rand(1..48).hours)
      rescue ActiveRecord::RecordInvalid
        # Skip if already liked
      end
    end
  end
end

def seed_messages(all_users, all_projects)
  messages_data = [
    { sender_idx: 0, project_idx: 0, content: "Hey team ! Bienvenue sur NexP ! Super content de vous avoir avec nous !", created_at: 2.months.ago },
    { sender_idx: 1, project_idx: 0, content: "Merci Greg ! Hate de commencer. On commence par quoi ?", created_at: 2.months.ago + 2.hours },
    { sender_idx: 0, project_idx: 0, content: "Je propose qu'on setup le projet Rails aujourd'hui et que Sarah commence sur le design du dashboard", created_at: 2.months.ago + 3.hours },
    { sender_idx: 8, project_idx: 0, content: "Perfect ! Je vais creer les wireframes ce week-end", created_at: 2.months.ago + 5.hours },
    { sender_idx: 14, project_idx: 0, content: "Je m'occupe du Docker Compose et de la CI/CD", created_at: 2.months.ago + 1.day },
    { sender_idx: 0, project_idx: 0, content: "Update: l'authentification est prete ! Sarah tu peux commencer l'integration", created_at: 1.month.ago },
    { sender_idx: 1, project_idx: 1, content: "Salut l'equipe ! Qui veut s'occuper du drag & drop des cards ?", created_at: 3.weeks.ago },
    { sender_idx: 4, project_idx: 1, content: "Je peux faire ca ! J'ai deja utilise react-beautiful-dnd", created_at: 3.weeks.ago + 1.hour },
    { sender_idx: 6, project_idx: 1, content: "Parfait ! Moi je vais bosser sur les animations de transition", created_at: 3.weeks.ago + 3.hours },
    { sender_idx: 10, project_idx: 4, content: "Le tracking GPS est operationnel !", created_at: 2.weeks.ago },
    { sender_idx: 12, project_idx: 4, content: "Super ! Le modele ML pour les recommandations est presque pret", created_at: 2.weeks.ago + 5.hours },
    { sender_idx: 9, project_idx: 4, content: "J'ai termine les ecrans de workout. Je vous envoie le Figma", created_at: 2.weeks.ago + 1.day },
    { sender_idx: 12, project_idx: 6, content: "La V1 du RAG est en prod ! Testez avec vos propres docs", created_at: 1.week.ago },
    { sender_idx: 13, project_idx: 6, content: "Wow c'est impressionnant ! La precision est top", created_at: 1.week.ago + 4.hours },
    { sender_idx: 4, project_idx: 8, content: "Meeting demain 14h pour faire le point sur le sprint ?", created_at: 5.days.ago },
    { sender_idx: 1, project_idx: 8, content: "Ok pour moi ! Je prepare une demo du panier", created_at: 5.days.ago + 1.hour },
    { sender_idx: 5, project_idx: 9, content: "L'API Go est deployee et stable !", created_at: 3.days.ago },
    { sender_idx: 0, project_idx: 9, content: "Excellent ! J'ai teste et c'est vraiment rapide", created_at: 3.days.ago + 3.hours },
    { sender_idx: 21, project_idx: 20, content: "Hello team! Le repo est pret, on commence par l'architecture de base ?", created_at: 3.weeks.ago },
    { sender_idx: 5, project_idx: 20, content: "Parfait ! Je propose qu'on use Tokio pour l'async runtime", created_at: 3.weeks.ago + 2.hours },
    { sender_idx: 21, project_idx: 20, content: "Update: le protocole Redis est compatible a 80% ! Les tests passent", created_at: 1.week.ago },
    { sender_idx: 22, project_idx: 21, content: "Salut ! Super excite de travailler sur ce projet de voyage", created_at: 1.month.ago },
    { sender_idx: 9, project_idx: 21, content: "Moi aussi ! J'ai deja quelques idees de design. Je vous montre ca demain", created_at: 1.month.ago + 3.hours },
    { sender_idx: 30, project_idx: 28, content: "Phoenix Channels time! Prets a scaler a 1M de connexions?", created_at: 3.weeks.ago },
    { sender_idx: 4, project_idx: 28, content: "Impressionnant ! Je n'ai jamais travaille avec Elixir mais j'ai hate d'apprendre", created_at: 3.weeks.ago + 3.hours },
    { sender_idx: 1, project_idx: 28, content: "Je m'occupe du client React avec Socket.io", created_at: 3.weeks.ago + 1.day },
    { sender_idx: 32, project_idx: 30, content: "Salut team! J'ai recu les capteurs Arduino, on peut commencer", created_at: 2.weeks.ago },
    { sender_idx: 34, project_idx: 30, content: "Cool ! C'est mon premier projet IoT, je vais apprendre plein de choses", created_at: 2.weeks.ago + 2.hours },
    { sender_idx: 34, project_idx: 31, content: "Mon premier vrai projet ! Qui veut m'aider a apprendre ?", created_at: 1.week.ago },
    { sender_idx: 16, project_idx: 31, content: "Moi aussi je suis junior, on va apprendre ensemble !", created_at: 1.week.ago + 1.hour },
    { sender_idx: 35, project_idx: 32, content: "Astro c'est trop cool ! Le blog charge en 0.5s", created_at: 1.week.ago },
    { sender_idx: 2, project_idx: 32, content: "Super ! J'ai commence a ecrire les premiers articles techniques", created_at: 1.week.ago + 3.hours }
  ]

  messages_data.each do |msg_data|
    Message.create!(
      sender: all_users[msg_data[:sender_idx]],
      project: all_projects[msg_data[:project_idx]],
      content: msg_data[:content],
      created_at: msg_data[:created_at]
    )
  end
end
