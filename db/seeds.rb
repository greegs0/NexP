# db/seeds.rb
# Seed complète et fournie pour NexP

puts "🧹 Nettoyage de la base..."
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

puts "✅ Base nettoyée !"

# ========================================
# 1️⃣ SKILLS - Toutes catégories
# ========================================

skills_data = {
  "Backend" => [
    "Ruby", "Ruby on Rails", "Python", "Django", "FastAPI", "Node.js", "Express.js",
    "PHP", "Laravel", "Java", "Spring Boot", "C#", ".NET", "Go", "Rust",
    "Bun", "Deno", "Hono", "tRPC", "NestJS", "AdonisJS", "Elixir", "Phoenix",
    "API REST", "GraphQL", "WebSockets", "Microservices", "Serverless",
    "Active Record", "Prisma", "TypeORM", "Sequelize", "Drizzle",
    "Background Jobs", "Sidekiq", "Bull", "Celery", "RabbitMQ", "Kafka", "gRPC", "NATS"
  ],

  "Frontend" => [
    "HTML", "CSS", "JavaScript", "TypeScript", "React", "Next.js", "Vue.js", "Nuxt.js",
    "Angular", "Svelte", "SvelteKit", "Solid.js", "Stimulus", "Turbo", "Hotwire",
    "Astro", "Qwik", "Preact", "htmx", "Alpine.js", "Remix",
    "Responsive Design", "Mobile First", "Tailwind CSS", "Bootstrap", "Material UI",
    "Styled Components", "CSS Modules", "SASS", "LESS", "PostCSS", "UnoCSS",
    "Redux", "Zustand", "Pinia", "MobX", "React Query", "SWR", "TanStack Query",
    "Webpack", "Vite", "esbuild", "Rollup", "Parcel", "Framer Motion", "GSAP"
  ],

  "Mobile" => [
    "React Native", "Flutter", "Swift", "SwiftUI", "Kotlin", "Android Studio",
    "Expo", "Ionic", "Capacitor", "Xamarin", "PWA", "Service Workers",
    "iOS Development", "Android Development", "Cross-Platform", "Native Development",
    "Dart", "Xcode", "Core Data", "Combine", "UIKit"
  ],

  "Database" => [
    "PostgreSQL", "MySQL", "SQLite", "MongoDB", "Redis", "Elasticsearch",
    "Firebase", "Supabase", "DynamoDB", "Cassandra", "Neo4j",
    "Database Design", "SQL Optimization", "Query Performance", "Indexing",
    "Data Modeling", "Migrations", "Backup & Recovery", "Replication", "InfluxDB"
  ],

  "DevOps" => [
    "Docker", "Kubernetes", "Git", "GitHub", "GitLab", "Bitbucket",
    "CI/CD", "GitHub Actions", "GitLab CI", "Jenkins", "CircleCI", "Travis CI",
    "AWS", "GCP", "Azure", "Heroku", "Vercel", "Netlify", "Railway", "Fly.io",
    "Cloudflare Workers", "Edge Computing", "Pulumi", "CloudFormation",
    "Terraform", "Ansible", "Nginx", "Apache", "Caddy", "Linux", "Bash", "Shell Scripting",
    "Monitoring", "Logging", "New Relic", "Datadog", "Sentry", "Grafana", "Prometheus"
  ],

  "IA & Data" => [
    "Machine Learning", "Deep Learning", "NLP", "Computer Vision",
    "TensorFlow", "PyTorch", "Keras", "scikit-learn", "JAX",
    "RAG", "LangChain", "LlamaIndex", "Vector Databases", "Pinecone", "Weaviate", "Chroma",
    "OpenAI", "Anthropic", "Claude API", "Cohere", "Hugging Face", "Mistral", "LLaMA",
    "Prompt Engineering", "Fine-tuning", "Embeddings", "LoRA", "RLHF",
    "Data Analysis", "Pandas", "NumPy", "Jupyter", "Data Visualization",
    "Tableau", "Power BI", "Matplotlib", "Seaborn", "Plotly", "Dash", "SQL", "Apache Spark"
  ],

  "Design" => [
    "UI/UX Design", "Figma", "Adobe XD", "Sketch", "InVision",
    "Prototyping", "Wireframing", "User Research", "Design Systems",
    "Photoshop", "Illustrator", "After Effects", "Blender", "3D Modeling",
    "Animation", "Motion Design", "Brand Design", "Logo Design",
    "Design Thinking", "User Testing", "Accessibility Design"
  ],

  "Product & Business" => [
    "Product Management", "Agile", "Scrum", "Kanban", "Jira",
    "Product Strategy", "Roadmapping", "User Stories", "Requirements",
    "Analytics", "Google Analytics", "Mixpanel", "Amplitude",
    "A/B Testing", "Growth Hacking", "SEO", "SEM", "Content Strategy",
    "Business Development", "Market Research", "Competitive Analysis"
  ],

  "Security" => [
    "Web Security", "OWASP", "Penetration Testing", "Security Audits",
    "Authentication", "OAuth", "JWT", "Session Management",
    "Encryption", "SSL/TLS", "HTTPS", "API Security",
    "Security Best Practices", "GDPR", "Privacy", "Compliance"
  ],

  "Testing & QA" => [
    "Test-Driven Development", "RSpec", "Jest", "Mocha", "Cypress",
    "Selenium", "Playwright", "Puppeteer", "Unit Testing", "Integration Testing",
    "E2E Testing", "Load Testing", "Performance Testing", "Code Coverage",
    "QA Automation", "Bug Tracking", "Quality Assurance"
  ],

  "Blockchain" => [
    "Solidity", "Smart Contracts", "Web3.js", "Ethers.js",
    "Ethereum", "Polygon", "Solana", "NFT", "DeFi",
    "Blockchain Architecture", "Cryptography", "Tokenomics", "IPFS"
  ],

  "Game Dev" => [
    "Unity", "Unreal Engine", "Godot", "C++", "Game Design",
    "Level Design", "3D Graphics", "2D Graphics",
    "Physics", "Multiplayer", "Game AI", "Shaders", "Photon"
  ],

  "Tools" => [
    "Electron", "Tauri", "Qt", "GTK", "wxWidgets",
    "WebAssembly", "Rust-WASM", "Emscripten", "Cross-Platform Apps"
  ],

  "Autre" => [
    "WebRTC", "Socket.io", "Real-time Apps", "IoT", "MQTT",
    "Arduino", "Raspberry Pi", "Edge AI",
    "Stripe", "Payment Integration", "Twilio", "SendGrid",
    "i18n", "Localization", "Accessibility"
  ]
}

all_skills = {}
skills_data.each do |category, names|
  names.each do |name|
    skill = Skill.create!(name: name, category: category)
    all_skills[name] = skill
  end
end

puts "✅ #{Skill.count} skills créées dans #{Skill.distinct.count(:category)} catégories"

# ========================================
# 2️⃣ BADGES
# ========================================

badges_data = [
  { name: "🚀 First Launch", description: "A créé son premier projet", xp_required: 0 },
  { name: "🤝 Team Player", description: "A rejoint 3 projets", xp_required: 100 },
  { name: "⭐ Rising Star", description: "A atteint le niveau 5", xp_required: 500 },
  { name: "🔥 On Fire", description: "A complété 5 projets", xp_required: 1000 },
  { name: "💎 Expert", description: "A atteint le niveau 10", xp_required: 2000 },
  { name: "🏆 Legend", description: "A complété 20 projets", xp_required: 5000 },
  { name: "👨‍💻 Code Ninja", description: "Contribution exceptionnelle au code", xp_required: 1500 },
  { name: "🎨 Design Master", description: "Excellence en design UI/UX", xp_required: 1500 },
  { name: "🧠 AI Pioneer", description: "Expert en Intelligence Artificielle", xp_required: 2500 },
  { name: "🌟 Community Champion", description: "Contribution active à la communauté", xp_required: 3000 }
]

all_badges = badges_data.map do |badge_data|
  Badge.create!(badge_data)
end

puts "✅ #{Badge.count} badges créés"

# ========================================
# 3️⃣ USERS - Profils variés et réalistes
# ========================================

users_data = [
  # Compte principal
  {
    email: "greg@nexp.dev",
    password: "azerty",
    name: "Grégory Lefebvre",
    username: "greegs0",
    bio: "Founder @NexP | Full-Stack Ruby on Rails Developer | Passionné par l'automatisation et l'optimisation. Toujours à la recherche de nouveaux défis techniques !",
    zipcode: "75001",
    github_url: "https://github.com/greegs0",
    linkedin_url: "https://linkedin.com/in/gregory-lefebvre",
    portfolio_url: "https://gregory-lefebvre.dev",
    experience_points: 5000,
    level: 12,
    available: true,
    skills: ["Ruby on Rails", "PostgreSQL", "JavaScript", "React", "Docker", "Git", "AWS", "Redis", "Stimulus", "Tailwind CSS"]
  },

  # Développeurs Full-Stack
  {
    email: "sarah.martin@gmail.com",
    password: "password123",
    name: "Sarah Martin",
    username: "sarahdev",
    bio: "Full-Stack Developer | React & Node.js enthusiast | Remote work advocate 🌍 | Building the future one component at a time",
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
    bio: "Développeur Full-Stack | Python & Django | Passionné de clean code et d'architecture logicielle | Open source contributor",
    zipcode: "33000",
    github_url: "https://github.com/thomasdev",
    linkedin_url: "https://linkedin.com/in/thomas-dubois",
    experience_points: 2800,
    level: 8,
    available: true,
    skills: ["Python", "Django", "PostgreSQL", "React", "Docker", "Git", "REST API", "Redis", "Celery", "Linux"]
  },

  {
    email: "emma.rousseau@protonmail.com",
    password: "password123",
    name: "Emma Rousseau",
    username: "emmacode",
    bio: "Senior Full-Stack Engineer | Vue.js & Laravel | Tech lead | Mentor | Code reviewer | Coffee addict ☕",
    zipcode: "44000",
    github_url: "https://github.com/emmacode",
    linkedin_url: "https://linkedin.com/in/emma-rousseau",
    portfolio_url: "https://emma-rousseau.dev",
    experience_points: 4500,
    level: 11,
    available: false,
    skills: ["Vue.js", "Laravel", "PHP", "MySQL", "Nuxt.js", "Tailwind CSS", "Git", "Docker", "CI/CD", "Nginx"]
  },

  # Développeurs Backend
  {
    email: "lucas.bernard@gmail.com",
    password: "password123",
    name: "Lucas Bernard",
    username: "lucasback",
    bio: "Backend Engineer | Node.js & Microservices | Performance optimization geek | Scalability enthusiast",
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
    bio: "API Architect | Go & Rust | Building high-performance systems | DevOps culture advocate",
    zipcode: "31000",
    github_url: "https://github.com/antoineapi",
    experience_points: 4000,
    level: 10,
    available: true,
    skills: ["Go", "Rust", "PostgreSQL", "Redis", "gRPC", "Docker", "Kubernetes", "Terraform", "Microservices", "API REST"]
  },

  # Développeurs Frontend
  {
    email: "julie.petit@gmail.com",
    password: "password123",
    name: "Julie Petit",
    username: "juliefront",
    bio: "Frontend Developer | React & TypeScript | UI perfectionist | Performance obsessed | Accessibility advocate ♿",
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
    bio: "Creative Frontend Developer | Vue.js wizard 🧙‍♂️ | Animation enthusiast | Always experimenting with new CSS tricks",
    zipcode: "67000",
    github_url: "https://github.com/maximefront",
    experience_points: 2200,
    level: 7,
    available: true,
    skills: ["Vue.js", "Nuxt.js", "JavaScript", "CSS", "SASS", "Animation", "Vite", "Pinia", "Tailwind CSS", "Figma"]
  },

  # Designers
  {
    email: "camille.garcia@gmail.com",
    password: "password123",
    name: "Camille Garcia",
    username: "camilledesign",
    bio: "UI/UX Designer | Product designer | Figma expert | Creating delightful user experiences ✨ | Design systems enthusiast",
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
    name: "Léa Roux",
    username: "learoux",
    bio: "Product Designer | Motion Design | Brand identity | Turning ideas into beautiful interfaces 🎨",
    zipcode: "69002",
    github_url: "https://github.com/learoux",
    portfolio_url: "https://lea-roux.design",
    experience_points: 2900,
    level: 8,
    available: true,
    skills: ["UI/UX Design", "Figma", "Motion Design", "After Effects", "Brand Design", "Prototyping", "Illustrator", "Design Systems", "Animation"]
  },

  # Développeurs Mobile
  {
    email: "nicolas.blanc@gmail.com",
    password: "password123",
    name: "Nicolas Blanc",
    username: "nicolasmobile",
    bio: "Mobile Developer | React Native & Flutter | Cross-platform expert | 50+ apps published 📱",
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
    name: "Chloé Fontaine",
    username: "chloeiOS",
    bio: "iOS Developer | Swift & SwiftUI | Apple ecosystem lover 🍎 | Clean architecture advocate",
    zipcode: "75015",
    github_url: "https://github.com/chloeiOS",
    experience_points: 2400,
    level: 7,
    available: true,
    skills: ["Swift", "SwiftUI", "iOS Development", "Xcode", "Core Data", "Combine", "UIKit", "Git"]
  },

  # Experts IA & Data
  {
    email: "pierre.lambert@gmail.com",
    password: "password123",
    name: "Pierre Lambert",
    username: "pierreai",
    bio: "AI/ML Engineer | PhD in Computer Science | Building intelligent systems | RAG & LLM specialist 🤖",
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
    bio: "Data Scientist | ML Engineer | Kaggle Master 🥇 | Turning data into insights | Python & R enthusiast",
    zipcode: "31000",
    github_url: "https://github.com/sophiedata",
    linkedin_url: "https://linkedin.com/in/sophie-mercier",
    experience_points: 4200,
    level: 11,
    available: true,
    skills: ["Python", "Machine Learning", "Data Analysis", "Pandas", "NumPy", "scikit-learn", "TensorFlow", "Jupyter", "SQL", "Data Visualization"]
  },

  # DevOps & Infra
  {
    email: "alexandre.bonnet@gmail.com",
    password: "password123",
    name: "Alexandre Bonnet",
    username: "alexdevops",
    bio: "DevOps Engineer | Kubernetes & Terraform | Cloud architecture | Infrastructure as Code | Automation first ⚡",
    zipcode: "69003",
    github_url: "https://github.com/alexdevops",
    linkedin_url: "https://linkedin.com/in/alexandre-bonnet",
    experience_points: 4600,
    level: 11,
    available: true,
    skills: ["Kubernetes", "Docker", "Terraform", "AWS", "GitLab CI", "Ansible", "Linux", "Bash", "Monitoring", "Nginx"]
  },

  # Product Managers
  {
    email: "marie.laurent@gmail.com",
    password: "password123",
    name: "Marie Laurent",
    username: "mariepm",
    bio: "Product Manager | Agile Coach | Building products users love ❤️ | Data-driven decision maker",
    zipcode: "75008",
    linkedin_url: "https://linkedin.com/in/marie-laurent",
    experience_points: 3000,
    level: 9,
    available: true,
    skills: ["Product Management", "Agile", "Scrum", "Jira", "User Stories", "Product Strategy", "Analytics", "A/B Testing", "Roadmapping"]
  },

  # Juniors motivés
  {
    email: "hugo.vincent@gmail.com",
    password: "password123",
    name: "Hugo Vincent",
    username: "hugodev",
    bio: "Junior Full-Stack Developer | Fresh bootcamp graduate | Ready to learn and grow 🌱 | Looking for my first project!",
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
    bio: "Aspiring UX Designer | Design student | Passionate about creating intuitive interfaces | Portfolio in progress 🎨",
    zipcode: "33000",
    portfolio_url: "https://clara-girard.com",
    experience_points: 400,
    level: 2,
    available: true,
    skills: ["UI/UX Design", "Figma", "Wireframing", "Prototyping", "User Research"]
  },

  # Freelances expérimentés
  {
    email: "david.morel@gmail.com",
    password: "password123",
    name: "David Morel",
    username: "davidfreelance",
    bio: "Freelance Full-Stack | 10+ years experience | Technical consultant | Building MVPs & scaling startups 🚀",
    zipcode: "13002",
    github_url: "https://github.com/davidfreelance",
    linkedin_url: "https://linkedin.com/in/david-morel",
    portfolio_url: "https://david-morel.com",
    experience_points: 6000,
    level: 15,
    available: false,
    skills: ["Ruby on Rails", "React", "PostgreSQL", "Redis", "Docker", "AWS", "Heroku", "Git", "CI/CD", "Agile"]
  },

  # Spécialistes Blockchain
  {
    email: "mathieu.durand@gmail.com",
    password: "password123",
    name: "Mathieu Durand",
    username: "mathieuweb3",
    bio: "Blockchain Developer | Solidity & Web3 | Smart contracts specialist | DeFi enthusiast | NFT creator 🔗",
    zipcode: "75009",
    github_url: "https://github.com/mathieuweb3",
    linkedin_url: "https://linkedin.com/in/mathieu-durand",
    experience_points: 3300,
    level: 9,
    available: true,
    skills: ["Solidity", "Web3.js", "Ethers.js", "Smart Contracts", "Ethereum", "React", "Node.js", "TypeScript"]
  },

  # Game Developers
  {
    email: "valentin.simon@gmail.com",
    password: "password123",
    name: "Valentin Simon",
    username: "valentingame",
    bio: "Game Developer | Unity & Unreal Engine | 3D Graphics | Creating immersive experiences 🎮",
    zipcode: "69006",
    github_url: "https://github.com/valentingame",
    portfolio_url: "https://valentin-simon.games",
    experience_points: 2700,
    level: 8,
    available: true,
    skills: ["Unity", "C#", "3D Graphics", "Game Design", "Shaders", "Physics", "Blender"]
  },

  # Nouveaux profils - Diversité géographique et compétences
  {
    email: "yasmine.benali@gmail.com",
    password: "password123",
    name: "Yasmine Benali",
    username: "yasminedev",
    bio: "Full-Stack Engineer | Rust enthusiast 🦀 | Performance optimization | WebAssembly pioneer | Open source contributor",
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
    bio: "Flutter Expert | Published 30+ apps | Tech speaker | Crafting beautiful mobile experiences 📱",
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
    name: "Océane Dubois",
    username: "oceanedesign",
    bio: "Motion Designer | After Effects wizard | Creating smooth animations | Brand identity specialist 🎬",
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
    bio: "Cloud Architect | AWS Certified Solutions Architect | Multi-cloud expert | Infrastructure as Code evangelist ☁️",
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
    bio: "Data Engineer | Building data pipelines | Apache Spark expert | Making data accessible and reliable 📊",
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
    bio: "Full-Stack Architect | Next.js & tRPC | TypeScript fanatic | Building type-safe apps from end to end 🔒",
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
    bio: "Senior UX Researcher | User-centered design advocate | Conducting user interviews | Data-driven design decisions 🔍",
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
    bio: "Security Engineer | Ethical hacker | OSCP certified | Protecting apps from threats | Bug bounty hunter 🛡️",
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
    name: "Élise Bernard",
    username: "elisefront",
    bio: "Frontend Engineer | Accessibility expert ♿ | Making the web inclusive for everyone | WCAG specialist",
    zipcode: "33000",
    github_url: "https://github.com/elisefront",
    linkedin_url: "https://linkedin.com/in/elise-bernard",
    experience_points: 3100,
    level: 9,
    available: true,
    skills: ["React", "TypeScript", "Accessibility Design", "Accessibility", "HTML", "CSS", "ARIA", "Responsive Design"]
  },

  {
    email: "theo.lambert@gmail.com",
    password: "password123",
    name: "Théo Lambert",
    username: "theoelixir",
    bio: "Elixir/Phoenix Developer | Functional programming lover | Building real-time systems | Erlang VM enthusiast 💜",
    zipcode: "59000",
    github_url: "https://github.com/theoelixir",
    linkedin_url: "https://linkedin.com/in/theo-lambert",
    experience_points: 3600,
    level: 10,
    available: true,
    skills: ["Elixir", "Phoenix", "PostgreSQL", "WebSockets", "Real-time Apps", "Functional Programming"]
  },

  {
    email: "pauline.girard@gmail.com",
    password: "password123",
    name: "Pauline Girard",
    username: "paulineqa",
    bio: "QA Engineer | Test automation specialist | Cypress & Playwright expert | Quality is not an option ✅",
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
    name: "Jérémy Morel",
    username: "jeremyiot",
    bio: "IoT Engineer | Arduino & Raspberry Pi | Edge computing | Making physical things smart 🤖",
    zipcode: "31000",
    github_url: "https://github.com/jeremyiot",
    experience_points: 2800,
    level: 8,
    available: true,
    skills: ["IoT", "Arduino", "Raspberry Pi", "Python", "C++", "MQTT", "Edge Computing", "Sensors"]
  },

  {
    email: "alice.fontaine@gmail.com",
    password: "password123",
    name: "Alice Fontaine",
    username: "alicepm",
    bio: "Technical Product Manager | Ex-developer turned PM | Bridging tech and business | User-focused roadmaps 📋",
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
    bio: "Junior Backend Developer | Python learner 🐍 | Looking for mentorship | Eager to contribute and grow!",
    zipcode: "35000",
    github_url: "https://github.com/yannjunior",
    experience_points: 600,
    level: 3,
    available: true,
    skills: ["Python", "FastAPI", "PostgreSQL", "Git", "Docker", "REST API"]
  },

  {
    email: "sarah.leclerc@gmail.com",
    password: "password123",
    name: "Sarah Leclerc",
    username: "sarahastro",
    bio: "Frontend Developer | Astro enthusiast 🚀 | SSG/SSR optimization | Performance-first mindset | Loves static sites",
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
    available: user_data[:available]
  )

  # Associer les skills
  if skills
    skills.each do |skill_name|
      if all_skills[skill_name]
        UserSkill.create!(user: user, skill: all_skills[skill_name])
      end
    end
  end

  # Attribuer des badges selon le niveau
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
    # Badges spéciaux selon les compétences
    if skills && (skills.include?("React") || skills.include?("Vue.js") || skills.include?("Angular"))
      UserBadge.create!(user: user, badge: all_badges[6], earned_at: 3.months.ago) # Code Ninja
    end
    if skills && (skills.include?("UI/UX Design") || skills.include?("Figma"))
      UserBadge.create!(user: user, badge: all_badges[7], earned_at: 3.months.ago) # Design Master
    end
  when 11..12
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 1.year.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 10.months.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 6.months.ago)
    UserBadge.create!(user: user, badge: all_badges[3], earned_at: 4.months.ago)
    UserBadge.create!(user: user, badge: all_badges[4], earned_at: 2.months.ago)
    # Badges spéciaux
    if skills && (skills.include?("Ruby on Rails") || skills.include?("React") || skills.include?("Python"))
      UserBadge.create!(user: user, badge: all_badges[6], earned_at: 5.months.ago) # Code Ninja
    end
    if skills && (skills.include?("UI/UX Design") || skills.include?("Figma") || skills.include?("Design Systems"))
      UserBadge.create!(user: user, badge: all_badges[7], earned_at: 5.months.ago) # Design Master
    end
    UserBadge.create!(user: user, badge: all_badges[9], earned_at: 3.months.ago) # Community Champion
  when 13..20
    UserBadge.create!(user: user, badge: all_badges[0], earned_at: 2.years.ago)
    UserBadge.create!(user: user, badge: all_badges[1], earned_at: 1.year.ago)
    UserBadge.create!(user: user, badge: all_badges[2], earned_at: 10.months.ago)
    UserBadge.create!(user: user, badge: all_badges[3], earned_at: 8.months.ago)
    UserBadge.create!(user: user, badge: all_badges[4], earned_at: 6.months.ago)
    UserBadge.create!(user: user, badge: all_badges[5], earned_at: 4.months.ago) # Legend
    # Badges spéciaux
    if skills && (skills.include?("Machine Learning") || skills.include?("RAG") || skills.include?("OpenAI"))
      UserBadge.create!(user: user, badge: all_badges[8], earned_at: 7.months.ago) # AI Pioneer
    end
    if skills && (skills.include?("Ruby on Rails") || skills.include?("React") || skills.include?("Go") || skills.include?("Rust"))
      UserBadge.create!(user: user, badge: all_badges[6], earned_at: 9.months.ago) # Code Ninja
    end
    if skills && (skills.include?("UI/UX Design") || skills.include?("Figma") || skills.include?("Design Systems"))
      UserBadge.create!(user: user, badge: all_badges[7], earned_at: 8.months.ago) # Design Master
    end
    UserBadge.create!(user: user, badge: all_badges[9], earned_at: 5.months.ago) # Community Champion
  end

  all_users << user
end

puts "✅ #{User.count} utilisateurs créés"

# ========================================
# 4️⃣ PROJECTS - Variés et réalistes
# ========================================

projects_data = [
  # Web Apps
  {
    owner: all_users[0], # Greg
    title: "NexP - Plateforme de Collaboration",
    description: "Plateforme web permettant de connecter des développeurs, designers et entrepreneurs pour créer des projets ensemble. Matching intelligent basé sur les skills, chat en temps réel, gestion de projets.\n\nFonctionnalités:\n- Système de matching par compétences\n- Dashboard collaboratif\n- Chat intégré par projet\n- Système de badges et gamification\n- API REST complète\n\nTech stack moderne avec Ruby on Rails 7, Hotwire, PostgreSQL, Redis, et Tailwind CSS.",
    status: "in_progress",
    max_members: 6,
    start_date: 2.months.ago,
    deadline: 3.months.from_now,
    skills: ["Ruby on Rails", "PostgreSQL", "JavaScript", "Stimulus", "Tailwind CSS", "Redis", "Docker", "Git"]
  },

  {
    owner: all_users[1], # Sarah
    title: "TaskFlow - Gestionnaire de Tâches Collaboratif",
    description: "Application de gestion de tâches moderne avec collaboration en temps réel. Alternative à Trello/Asana.\n\nCaractéristiques:\n- Boards Kanban\n- Collaboration temps réel\n- Notifications push\n- Mobile responsive\n- Dark mode\n- Export PDF/CSV\n\nStack: React, Node.js, MongoDB, Socket.io, Redux, Material-UI",
    status: "in_progress",
    max_members: 4,
    start_date: 1.month.ago,
    deadline: 2.months.from_now,
    skills: ["React", "Node.js", "MongoDB", "Socket.io", "TypeScript", "Redux", "Material UI"]
  },

  {
    owner: all_users[2], # Thomas
    title: "BlogHub - Plateforme de Blogging",
    description: "Plateforme de blogging moderne avec markdown, SEO optimisé, et système de tags avancé.\n\nFonctionnalités:\n- Éditeur markdown WYSIWYG\n- SEO optimization automatique\n- Système de tags et catégories\n- Commentaires et likes\n- Newsletter intégrée\n- Analytics dashboard\n\nTech: Django, PostgreSQL, React, Celery, Redis",
    status: "open",
    max_members: 3,
    start_date: 2.weeks.ago,
    deadline: 4.months.from_now,
    skills: ["Django", "PostgreSQL", "React", "Celery", "Redis", "SEO"]
  },

  {
    owner: all_users[3], # Emma
    title: "EcoTrack - Calculateur d'Empreinte Carbone",
    description: "Application web pour calculer et suivre son empreinte carbone personnelle.\n\nModules:\n- Calcul empreinte transport\n- Suivi alimentation\n- Consommation énergie\n- Recommandations personnalisées\n- Challenges communautaires\n- Graphiques et statistiques\n\nStack: Vue.js 3, Laravel, MySQL, Chart.js",
    status: "completed",
    max_members: 4,
    start_date: 4.months.ago,
    end_date: 1.month.ago,
    skills: ["Vue.js", "Laravel", "MySQL", "Chart.js", "Nuxt.js", "Tailwind CSS"]
  },

  # Mobile Apps
  {
    owner: all_users[10], # Nicolas
    title: "FitBuddy - Coach Sportif Personnel",
    description: "Application mobile de coaching sportif avec IA pour des programmes personnalisés.\n\nFonctionnalités:\n- Programmes d'entraînement personnalisés\n- Suivi nutrition\n- Tracking des performances\n- Vidéos d'exercices\n- Notifications intelligentes\n- Synchronisation wearables\n\nCross-platform: React Native, Firebase, TensorFlow Lite",
    status: "in_progress",
    max_members: 5,
    start_date: 3.weeks.ago,
    deadline: 5.months.from_now,
    skills: ["React Native", "Firebase", "TypeScript", "TensorFlow", "Expo", "Redux"]
  },

  {
    owner: all_users[11], # Chloé
    title: "MindfulMe - Méditation & Bien-être",
    description: "App iOS de méditation guidée avec contenu quotidien personnalisé.\n\nContenu:\n- 200+ méditations guidées\n- Exercices de respiration\n- Musique relaxante\n- Suivi d'humeur\n- Rappels personnalisés\n- Widgets iOS\n\nNative iOS: SwiftUI, Core Data, HealthKit",
    status: "open",
    max_members: 3,
    start_date: 1.week.ago,
    deadline: 3.months.from_now,
    skills: ["Swift", "SwiftUI", "iOS Development", "Core Data", "Animation"]
  },

  # IA & Data
  {
    owner: all_users[12], # Pierre
    title: "DocuMind - Assistant IA pour Documents",
    description: "Assistant IA intelligent pour analyser, résumer et interroger vos documents (PDF, Word, etc.).\n\nCapacités:\n- RAG (Retrieval Augmented Generation)\n- Multi-documents analysis\n- Résumés automatiques\n- Q&A sur documents\n- Export structuré\n- API accessible\n\nTech: Python, LangChain, OpenAI, FastAPI, Pinecone, PostgreSQL",
    status: "in_progress",
    max_members: 4,
    start_date: 1.month.ago,
    deadline: 4.months.from_now,
    skills: ["Python", "RAG", "LangChain", "OpenAI", "FastAPI", "PostgreSQL", "Vector Databases"]
  },

  {
    owner: all_users[13], # Sophie
    title: "PredictStock - ML pour Prédiction Boursière",
    description: "Système de machine learning pour analyser et prédire les tendances boursières.\n\nModèles:\n- LSTM pour séries temporelles\n- Analyse de sentiment des news\n- Corrélations multi-assets\n- Backtesting automatique\n- Dashboard interactif\n\nStack: Python, TensorFlow, Pandas, Dash, PostgreSQL",
    status: "open",
    max_members: 3,
    start_date: 2.days.ago,
    deadline: 6.months.from_now,
    skills: ["Python", "Machine Learning", "TensorFlow", "Data Analysis", "Pandas", "PostgreSQL"]
  },

  # E-commerce
  {
    owner: all_users[4], # Lucas
    title: "LocalMarket - Marketplace Local",
    description: "Marketplace pour produits locaux avec système de livraison intégré.\n\nFonctionnalités:\n- Catalogue produits\n- Paiement en ligne (Stripe)\n- Système de livraison\n- Avis et notes\n- Chat vendeur/acheteur\n- Dashboard vendeur\n- Mobile app\n\nMicroservices: Node.js, PostgreSQL, Redis, React, React Native",
    status: "in_progress",
    max_members: 8,
    start_date: 2.months.ago,
    deadline: 6.months.from_now,
    skills: ["Node.js", "React", "React Native", "PostgreSQL", "Redis", "Microservices", "Stripe"]
  },

  # SaaS
  {
    owner: all_users[5], # Antoine
    title: "CodeReview.ai - Review de Code par IA",
    description: "SaaS de review automatique de code avec suggestions d'amélioration par IA.\n\nFonctionnalités:\n- Analyse statique avancée\n- Détection bugs et vulnérabilités\n- Suggestions IA (GPT-4)\n- Intégration GitHub/GitLab\n- Métriques qualité code\n- CI/CD integration\n\nStack: Go, PostgreSQL, OpenAI, React, Kubernetes",
    status: "in_progress",
    max_members: 5,
    start_date: 3.weeks.ago,
    deadline: 5.months.from_now,
    skills: ["Go", "PostgreSQL", "OpenAI", "React", "Kubernetes", "Docker", "Git"]
  },

  # Design & Creative
  {
    owner: all_users[8], # Camille
    title: "DesignSystem Pro - Générateur de Design Systems",
    description: "Outil en ligne pour créer et maintenir des design systems complets.\n\nOutils:\n- Générateur de composants\n- Color palette generator\n- Typography system\n- Export Figma/Sketch\n- Documentation auto\n- Code snippets\n\nTech: React, TypeScript, Figma API, Storybook",
    status: "open",
    max_members: 4,
    skills: ["React", "TypeScript", "Figma", "Design Systems", "Storybook", "UI/UX Design"]
  },

  # DevOps
  {
    owner: all_users[14], # Alexandre
    title: "DeployMaster - Plateforme de Déploiement",
    description: "Alternative open-source à Vercel/Netlify pour déployer facilement vos apps.\n\nFeatures:\n- Auto-deploy from Git\n- Custom domains\n- SSL automatique\n- CI/CD intégré\n- Logs en temps réel\n- Scaling automatique\n- Preview deployments\n\nInfra: Kubernetes, Terraform, Go, React, PostgreSQL",
    status: "in_progress",
    max_members: 6,
    start_date: 1.month.ago,
    deadline: 8.months.from_now,
    skills: ["Kubernetes", "Docker", "Terraform", "Go", "React", "PostgreSQL", "CI/CD"]
  },

  # Social & Community
  {
    owner: all_users[15], # Marie
    title: "SkillShare - Échange de Compétences",
    description: "Plateforme d'échange de compétences peer-to-peer (je t'apprends X, tu m'apprends Y).\n\nConcept:\n- Profils de compétences\n- Matching intelligent\n- Système de points\n- Visio intégrée\n- Planning sessions\n- Avis et certifications\n\nStack: Ruby on Rails, PostgreSQL, WebRTC, React, Redis",
    status: "open",
    max_members: 5,
    deadline: 4.months.from_now,
    skills: ["Ruby on Rails", "PostgreSQL", "React", "WebRTC", "Redis"]
  },

  # Blockchain
  {
    owner: all_users[19], # Mathieu
    title: "NFTGallery - Galerie NFT Communautaire",
    description: "Plateforme décentralisée pour créer, vendre et collectionner des NFTs artistiques.\n\nFonctionnalités:\n- Mint NFT (Polygon)\n- Marketplace intégré\n- Wallet connection\n- Galeries personnalisées\n- Enchères\n- Royalties automatiques\n\nWeb3 Stack: Solidity, Ethers.js, React, IPFS, The Graph",
    status: "in_progress",
    max_members: 4,
    start_date: 3.weeks.ago,
    deadline: 5.months.from_now,
    skills: ["Solidity", "Web3.js", "Ethers.js", "React", "Smart Contracts", "IPFS"]
  },

  # Gaming
  {
    owner: all_users[20], # Valentin
    title: "PixelQuest - RPG 2D Multijoueur",
    description: "Jeu RPG 2D en ligne inspiré de Stardew Valley et Terraria.\n\nGameplay:\n- Monde procédural\n- Craft & construction\n- Combat PvE/PvP\n- Quêtes et histoires\n- Multijoueur (50+ joueurs)\n- Cross-platform\n\nEngine: Unity, C#, Photon, PostgreSQL",
    status: "in_progress",
    max_members: 10,
    start_date: 2.months.ago,
    deadline: 1.year.from_now,
    skills: ["Unity", "C#", "Game Design", "Multiplayer", "3D Graphics", "Photoshop"]
  },

  # Projets juniors
  {
    owner: all_users[16], # Hugo
    title: "QuizApp - Application de Quiz Interactifs",
    description: "Application web simple pour créer et partager des quiz interactifs.\n\nIdéal pour premier projet!\n\nFeatures:\n- Création de quiz\n- Score et classement\n- Partage par lien\n- Timer optionnel\n- Responsive design\n\nStack: React, Node.js, MongoDB",
    status: "open",
    max_members: 3,
    deadline: 2.months.from_now,
    skills: ["React", "Node.js", "MongoDB", "HTML", "CSS", "JavaScript"]
  },

  {
    owner: all_users[17], # Clara
    title: "PortfolioBuilder - Générateur de Portfolios",
    description: "Outil no-code pour créer son portfolio en quelques clics.\n\nPour les créatifs qui veulent un portfolio sans coder!\n\nFeatures:\n- Templates prêts à l'emploi\n- Drag & drop\n- Responsive\n- Custom domain\n- Analytics\n\nStack: Vue.js, Firebase",
    status: "open",
    max_members: 2,
    deadline: 3.months.from_now,
    skills: ["Vue.js", "Firebase", "UI/UX Design", "Figma"]
  },

  # Projects completed
  {
    owner: all_users[18], # David
    title: "WeatherNow - API Météo Avancée",
    description: "API REST pour données météo avec prédictions ML et alertes.",
    status: "completed",
    max_members: 3,
    start_date: 6.months.ago,
    end_date: 2.months.ago,
    skills: ["Python", "FastAPI", "Machine Learning", "PostgreSQL", "Redis"]
  },

  {
    owner: all_users[6], # Julie
    title: "AnimateCSS Pro - Bibliothèque d'Animations",
    description: "Collection d'animations CSS modernes et performantes.",
    status: "completed",
    max_members: 2,
    start_date: 4.months.ago,
    end_date: 1.month.ago,
    skills: ["CSS", "JavaScript", "Animation", "Responsive Design"]
  },

  # Projets variés supplémentaires
  {
    owner: all_users[7], # Maxime
    title: "SmartHome Dashboard",
    description: "Dashboard centralisé pour domotique (Philips Hue, Nest, etc.).\n\nIntégrations:\n- Lumières connectées\n- Thermostats\n- Caméras\n- Serrures\n- Capteurs\n- Automatisations\n\nStack: Vue.js, Node.js, MQTT, InfluxDB",
    status: "in_progress",
    max_members: 4,
    start_date: 2.weeks.ago,
    deadline: 4.months.from_now,
    skills: ["Vue.js", "Node.js", "IoT", "MQTT", "WebSockets", "Tailwind CSS"]
  },

  {
    owner: all_users[9], # Léa
    title: "LogoAI - Générateur de Logos par IA",
    description: "Générateur de logos professionels avec IA.\n\nFeatures:\n- Génération IA (DALL-E)\n- Customisation avancée\n- Export multi-formats\n- Brand kit complet\n- Color palette\n\nTech: React, Python, OpenAI, FastAPI",
    status: "open",
    max_members: 3,
    deadline: 3.months.from_now,
    skills: ["React", "Python", "OpenAI", "UI/UX Design", "Brand Design"]
  },

  # Nouveaux projets variés
  {
    owner: all_users[21], # Yasmine
    title: "RustCache - Système de Cache Distribué",
    description: "Cache distribué haute performance écrit en Rust.\n\nFeatures:\n- Ultra-low latency\n- Distributed architecture\n- Redis protocol compatible\n- Cluster mode\n- Persistence options\n- Monitoring dashboard\n\nStack: Rust, WebAssembly, Tokio, PostgreSQL",
    status: "in_progress",
    max_members: 4,
    start_date: 3.weeks.ago,
    deadline: 5.months.from_now,
    skills: ["Rust", "WebAssembly", "Performance Optimization", "Docker", "Kubernetes"]
  },

  {
    owner: all_users[22], # Baptiste
    title: "TravelMate - Guide de Voyage Communautaire",
    description: "App mobile pour découvrir et partager des lieux de voyage authentiques.\n\nFonctionnalités:\n- Carte interactive\n- Recommandations AI\n- Hors-ligne mode\n- Itinéraires personnalisés\n- Social features\n- AR navigation\n\nCross-platform: Flutter, Firebase, Google Maps API",
    status: "in_progress",
    max_members: 5,
    start_date: 1.month.ago,
    deadline: 4.months.from_now,
    skills: ["Flutter", "Dart", "Firebase", "Mobile First", "Google Maps", "AR"]
  },

  {
    owner: all_users[24], # Romain
    title: "CloudCost - Optimiseur de Coûts Cloud",
    description: "SaaS pour analyser et optimiser les dépenses cloud (AWS, GCP, Azure).\n\nFeatures:\n- Multi-cloud analysis\n- Cost forecasting\n- Recommendations AI\n- Automated actions\n- Alerts & reports\n- Team collaboration\n\nInfra: Go, PostgreSQL, React, Terraform, Kubernetes",
    status: "in_progress",
    max_members: 6,
    start_date: 2.months.ago,
    deadline: 6.months.from_now,
    skills: ["AWS", "GCP", "Azure", "Terraform", "Go", "React", "PostgreSQL", "Kubernetes"]
  },

  {
    owner: all_users[25], # Laura
    title: "DataFlow - Plateforme ETL No-Code",
    description: "Plateforme visuelle pour créer des pipelines de données sans coder.\n\nCapacités:\n- Drag & drop builder\n- 100+ connectors\n- Data transformation\n- Scheduling\n- Monitoring\n- Version control\n\nStack: Python, Apache Spark, React, PostgreSQL, Airflow",
    status: "open",
    max_members: 5,
    deadline: 7.months.from_now,
    skills: ["Python", "Apache Spark", "React", "PostgreSQL", "Data Analysis", "ETL"]
  },

  {
    owner: all_users[26], # Kevin
    title: "FormCraft - Générateur de Formulaires Intelligents",
    description: "Créer des formulaires dynamiques avec validation et logique conditionnelle.\n\nFeatures:\n- Visual builder\n- Conditional logic\n- Multi-step forms\n- File uploads\n- Payment integration\n- Analytics dashboard\n- API & webhooks\n\nStack: Next.js, tRPC, Prisma, PostgreSQL, Stripe",
    status: "in_progress",
    max_members: 4,
    start_date: 2.weeks.ago,
    deadline: 4.months.from_now,
    skills: ["Next.js", "tRPC", "TypeScript", "Prisma", "PostgreSQL", "React"]
  },

  {
    owner: all_users[27], # Agathe
    title: "UserLab - Plateforme de Tests Utilisateurs",
    description: "Recrutement et gestion de tests utilisateurs à distance.\n\nServices:\n- User panel management\n- Test scheduling\n- Screen recording\n- Heatmaps & analytics\n- Reports generation\n- Participant rewards\n\nTech: Vue.js, Laravel, PostgreSQL, WebRTC",
    status: "open",
    max_members: 4,
    deadline: 5.months.from_now,
    skills: ["Vue.js", "Laravel", "PostgreSQL", "User Research", "Analytics", "WebRTC"]
  },

  {
    owner: all_users[28], # Mehdi
    title: "SecureCheck - Scanner de Vulnérabilités",
    description: "Outil automatisé pour scanner les vulnérabilités web et API.\n\nCapacités:\n- OWASP Top 10 detection\n- API security testing\n- Dependency scanning\n- CI/CD integration\n- Compliance reports\n- Remediation guides\n\nStack: Python, Go, React, PostgreSQL, Docker",
    status: "in_progress",
    max_members: 4,
    start_date: 1.month.ago,
    deadline: 5.months.from_now,
    skills: ["Python", "Go", "Web Security", "OWASP", "Penetration Testing", "Docker"]
  },

  {
    owner: all_users[29], # Élise
    title: "A11yKit - Bibliothèque de Composants Accessibles",
    description: "Composants React accessibles (WCAG AAA) prêts à l'emploi.\n\nComposants:\n- Forms & inputs\n- Navigation\n- Modals & dialogs\n- Data tables\n- Charts accessibles\n- Documentation complète\n\nStack: React, TypeScript, Storybook, Jest",
    status: "open",
    max_members: 3,
    deadline: 4.months.from_now,
    skills: ["React", "TypeScript", "Accessibility Design", "Accessibility", "Storybook", "Jest"]
  },

  {
    owner: all_users[30], # Théo
    title: "ChatStream - Plateforme de Chat Temps Réel",
    description: "Infrastructure de chat scalable avec Phoenix Channels.\n\nFeatures:\n- Millions de connexions simultanées\n- Rooms & channels\n- Typing indicators\n- Read receipts\n- File sharing\n- E2E encryption option\n\nStack: Elixir, Phoenix, PostgreSQL, React",
    status: "in_progress",
    max_members: 4,
    start_date: 3.weeks.ago,
    deadline: 5.months.from_now,
    skills: ["Elixir", "Phoenix", "PostgreSQL", "Real-time Apps", "WebSockets", "React"]
  },

  {
    owner: all_users[31], # Pauline
    title: "TestMaster - Plateforme de Test Management",
    description: "Gestion centralisée des tests et de la qualité logicielle.\n\nFeatures:\n- Test case management\n- Test execution tracking\n- Bug integration (Jira, etc.)\n- CI/CD integration\n- Reports & metrics\n- Team collaboration\n\nStack: React, Node.js, PostgreSQL, Cypress",
    status: "open",
    max_members: 3,
    deadline: 4.months.from_now,
    skills: ["React", "Node.js", "PostgreSQL", "Cypress", "QA Automation", "Jest"]
  },

  {
    owner: all_users[32], # Jérémy
    title: "SmartGarden - Jardin Connecté",
    description: "Système IoT pour automatiser l'entretien de son jardin.\n\nFeatures:\n- Capteurs humidité/température\n- Arrosage automatique\n- Monitoring en temps réel\n- Alertes smartphone\n- Historique & analytics\n- Solar powered\n\nStack: Arduino, Raspberry Pi, Python, MQTT, React Native",
    status: "in_progress",
    max_members: 4,
    start_date: 2.weeks.ago,
    deadline: 4.months.from_now,
    skills: ["IoT", "Arduino", "Raspberry Pi", "Python", "MQTT", "React Native"]
  },

  {
    owner: all_users[34], # Yann (junior)
    title: "RecipeBox - Application de Recettes",
    description: "App simple pour gérer ses recettes de cuisine.\n\nIdéal pour apprendre!\n\nFeatures:\n- CRUD recettes\n- Upload photos\n- Tags & catégories\n- Liste de courses\n- Timer de cuisine\n- Partage recettes\n\nStack: Python, FastAPI, React, PostgreSQL",
    status: "open",
    max_members: 3,
    deadline: 3.months.from_now,
    skills: ["Python", "FastAPI", "React", "PostgreSQL", "REST API"]
  },

  {
    owner: all_users[35], # Sarah (Astro)
    title: "TechBlog - Blog Technique Performant",
    description: "Blog technique avec Astro pour des performances optimales.\n\nCaractéristiques:\n- SSG ultra-rapide\n- MDX support\n- Syntax highlighting\n- Dark mode\n- RSS feed\n- SEO optimized\n- Analytics\n\nStack: Astro, React, Tailwind CSS, MDX",
    status: "in_progress",
    max_members: 2,
    start_date: 1.week.ago,
    deadline: 2.months.from_now,
    skills: ["Astro", "React", "TypeScript", "Tailwind CSS", "SEO", "Performance Optimization"]
  },

  # Plus de projets complétés pour l'historique
  {
    owner: all_users[11], # Chloé
    title: "NotesApp - Application de Notes",
    description: "App iOS native pour prendre des notes avec markdown.",
    status: "completed",
    max_members: 2,
    start_date: 5.months.ago,
    end_date: 2.months.ago,
    skills: ["Swift", "SwiftUI", "iOS Development", "Core Data"]
  },

  {
    owner: all_users[23], # Océane
    title: "BrandKit - Kit de Marque Automatisé",
    description: "Générateur automatique de brand kits pour startups.",
    status: "completed",
    max_members: 3,
    start_date: 8.months.ago,
    end_date: 4.months.ago,
    skills: ["Brand Design", "Motion Design", "Figma", "After Effects"]
  },

  {
    owner: all_users[7], # Maxime
    title: "AnimeDex - Base de données d'anime",
    description: "Application web pour découvrir et suivre des animes.",
    status: "completed",
    max_members: 3,
    start_date: 7.months.ago,
    end_date: 3.months.ago,
    skills: ["Vue.js", "Nuxt.js", "PostgreSQL", "Tailwind CSS"]
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

  # Associer les skills
  if skills
    skills.each do |skill_name|
      if all_skills[skill_name]
        ProjectSkill.create!(project: project, skill: all_skills[skill_name])
      end
    end
  end

  all_projects << project
end

puts "✅ #{Project.count} projets créés"

# ========================================
# 5️⃣ TEAMS - Membres des projets
# ========================================

teams_data = [
  # NexP team
  { user: all_users[1], project: all_projects[0], role: "Frontend Developer", status: "accepted" },
  { user: all_users[8], project: all_projects[0], role: "UI/UX Designer", status: "accepted" },
  { user: all_users[14], project: all_projects[0], role: "DevOps Engineer", status: "accepted" },

  # TaskFlow team
  { user: all_users[4], project: all_projects[1], role: "Backend Developer", status: "accepted" },
  { user: all_users[6], project: all_projects[1], role: "Frontend Developer", status: "accepted" },

  # BlogHub team
  { user: all_users[16], project: all_projects[2], role: "Junior Developer", status: "accepted" },

  # FitBuddy team
  { user: all_users[12], project: all_projects[4], role: "AI/ML Engineer", status: "accepted" },
  { user: all_users[9], project: all_projects[4], role: "UI/UX Designer", status: "accepted" },

  # DocuMind team
  { user: all_users[13], project: all_projects[6], role: "Data Scientist", status: "accepted" },
  { user: all_users[5], project: all_projects[6], role: "Backend Engineer", status: "pending" },

  # LocalMarket team
  { user: all_users[1], project: all_projects[8], role: "Frontend Lead", status: "accepted" },
  { user: all_users[10], project: all_projects[8], role: "Mobile Developer", status: "accepted" },
  { user: all_users[8], project: all_projects[8], role: "Product Designer", status: "accepted" },

  # CodeReview.ai team
  { user: all_users[0], project: all_projects[9], role: "Technical Advisor", status: "accepted" },
  { user: all_users[6], project: all_projects[9], role: "Frontend Developer", status: "accepted" },

  # DeployMaster team
  { user: all_users[5], project: all_projects[11], role: "Backend Engineer", status: "accepted" },
  { user: all_users[7], project: all_projects[11], role: "Frontend Developer", status: "pending" },

  # NFTGallery team
  { user: all_users[1], project: all_projects[13], role: "Frontend Developer", status: "accepted" },

  # PixelQuest team
  { user: all_users[9], project: all_projects[14], role: "Game Designer", status: "accepted" },
  { user: all_users[17], project: all_projects[14], role: "UI Designer", status: "pending" },

  # SmartHome team
  { user: all_users[4], project: all_projects[19], role: "Backend Developer", status: "accepted" },

  # RustCache team
  { user: all_users[5], project: all_projects[20], role: "Backend Engineer", status: "accepted" },
  { user: all_users[14], project: all_projects[20], role: "DevOps Engineer", status: "accepted" },

  # TravelMate team
  { user: all_users[9], project: all_projects[21], role: "UI/UX Designer", status: "accepted" },
  { user: all_users[10], project: all_projects[21], role: "Mobile Developer", status: "pending" },
  { user: all_users[12], project: all_projects[21], role: "AI Engineer", status: "accepted" },

  # CloudCost team
  { user: all_users[14], project: all_projects[22], role: "Infrastructure Lead", status: "accepted" },
  { user: all_users[5], project: all_projects[22], role: "Backend Developer", status: "accepted" },
  { user: all_users[6], project: all_projects[22], role: "Frontend Developer", status: "accepted" },
  { user: all_users[0], project: all_projects[22], role: "Technical Advisor", status: "accepted" },

  # DataFlow team
  { user: all_users[13], project: all_projects[23], role: "Data Scientist", status: "pending" },
  { user: all_users[1], project: all_projects[23], role: "Frontend Developer", status: "pending" },

  # FormCraft team
  { user: all_users[6], project: all_projects[24], role: "Frontend Developer", status: "accepted" },
  { user: all_users[8], project: all_projects[24], role: "Product Designer", status: "accepted" },

  # UserLab team
  { user: all_users[27], project: all_projects[25], role: "UX Lead", status: "accepted" },
  { user: all_users[7], project: all_projects[25], role: "Frontend Developer", status: "pending" },

  # SecureCheck team
  { user: all_users[5], project: all_projects[26], role: "Backend Engineer", status: "accepted" },
  { user: all_users[31], project: all_projects[26], role: "QA Engineer", status: "accepted" },

  # A11yKit team
  { user: all_users[6], project: all_projects[27], role: "Frontend Developer", status: "pending" },
  { user: all_users[27], project: all_projects[27], role: "UX Consultant", status: "accepted" },

  # ChatStream team
  { user: all_users[4], project: all_projects[28], role: "Backend Developer", status: "accepted" },
  { user: all_users[1], project: all_projects[28], role: "Frontend Developer", status: "accepted" },

  # TestMaster team
  { user: all_users[2], project: all_projects[29], role: "Backend Developer", status: "pending" },

  # SmartGarden team
  { user: all_users[34], project: all_projects[30], role: "Junior Developer", status: "accepted" },
  { user: all_users[7], project: all_projects[30], role: "Frontend Developer", status: "accepted" },

  # RecipeBox team
  { user: all_users[16], project: all_projects[31], role: "Junior Developer", status: "accepted" },

  # TechBlog team
  { user: all_users[2], project: all_projects[32], role: "Content Writer", status: "accepted" },

  # Anciens projets complétés - avec historique
  { user: all_users[9], project: all_projects[33], role: "Designer", status: "accepted", joined_at: 5.months.ago },
  { user: all_users[8], project: all_projects[34], role: "Lead Designer", status: "accepted", joined_at: 8.months.ago },
  { user: all_users[23], project: all_projects[34], role: "Motion Designer", status: "accepted", joined_at: 8.months.ago },
  { user: all_users[6], project: all_projects[35], role: "Developer", status: "accepted", joined_at: 7.months.ago },

  # Plus de membres dans les projets existants
  { user: all_users[21], project: all_projects[9], role: "Performance Engineer", status: "accepted" },
  { user: all_users[26], project: all_projects[1], role: "Full-Stack Developer", status: "accepted" },
  { user: all_users[29], project: all_projects[10], role: "Accessibility Consultant", status: "pending" },
  { user: all_users[31], project: all_projects[9], role: "QA Lead", status: "accepted" },
  { user: all_users[35], project: all_projects[2], role: "Frontend Developer", status: "accepted" },
  { user: all_users[22], project: all_projects[4], role: "Mobile Developer", status: "pending" },
  { user: all_users[25], project: all_projects[6], role: "Data Engineer", status: "accepted" },
  { user: all_users[27], project: all_projects[8], role: "Product Designer", status: "accepted" },
  { user: all_users[30], project: all_projects[12], role: "Backend Developer", status: "pending" },
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

puts "✅ #{Team.count} membres ajoutés aux projets"

# ========================================
# 6️⃣ POSTS - Activité sociale
# ========================================

posts_data = [
  {
    user: all_users[0],
    content: "🚀 Super excité de lancer NexP ! Une plateforme pour connecter builders et créer des projets incroyables ensemble. Qui est partant pour rejoindre l'aventure ? #buildinpublic #startup"
  },
  {
    user: all_users[1],
    content: "Viens de terminer le redesign complet de TaskFlow ! Les animations sont ultra smooth maintenant. React + Framer Motion = ❤️ #frontend #react"
  },
  {
    user: all_users[12],
    content: "Après 2 semaines de dev, notre système RAG atteint enfin 95% de précision sur les requêtes complexes ! LangChain + GPT-4 c'est vraiment puissant. 🤖 #AI #machinelearning"
  },
  {
    user: all_users[8],
    content: "Nouveau design system en cours pour un client ! J'adore créer des composants réutilisables et cohérents. Figma est mon terrain de jeu préféré 🎨 #design #figma"
  },
  {
    user: all_users[10],
    content: "50k téléchargements sur notre app ! Merci à toute la communauté qui nous soutient 🙏 React Native FTW! #mobile #reactnative"
  },
  {
    user: all_users[14],
    content: "Migration vers Kubernetes terminée avec succès ! 99.99% uptime et déploiements 10x plus rapides. Le DevOps c'est la vie 🔧 #devops #kubernetes"
  },
  {
    user: all_users[16],
    content: "Mon premier projet open-source ! C'est pas parfait mais je suis fier du chemin parcouru. Feedback welcome ! 💪 #junior #learning"
  },
  {
    user: all_users[19],
    content: "Notre smart contract est déployé sur mainnet ! 🎉 Les NFTs mintent comme des petits pains. Web3 is here! #blockchain #web3"
  },
  {
    user: all_users[3],
    content: "Code review de la semaine : toujours préférer la composition à l'héritage ! Laravel rend ça tellement élégant. #php #cleancode"
  },
  {
    user: all_users[13],
    content: "Notre modèle ML vient de battre le baseline de 15% ! Les features engineering c'est vraiment de l'art 📊 #datascience #ml"
  },
  {
    user: all_users[15],
    content: "Sprint planning done ✅ L'équipe est super motivée pour les 2 prochaines semaines ! Agile > tout #productmanagement #agile"
  },
  {
    user: all_users[6],
    content: "TIL: CSS container queries changent vraiment la donne pour le responsive design. Plus besoin de media queries partout ! 🤯 #css #frontend"
  },
  {
    user: all_users[2],
    content: "Django 5.0 est incroyable ! Les amélioration de performance sont bluffantes. Python reste le meilleur pour le backend 🐍 #python #django"
  },
  {
    user: all_users[20],
    content: "16 heures de dev aujourd'hui sur le système de combat... Unity c'est addictif 😅🎮 #gamedev #unity"
  },
  {
    user: all_users[17],
    content: "Feedback sur mes maquettes = super positifs ! Je progresse chaque jour 🌱 #designer #learning"
  },

  # Nouveaux posts pour plus d'activité
  {
    user: all_users[21],
    content: "Rust c'est vraiment incroyable pour la performance ! Notre cache distribué atteint 1M req/s avec 0 downtime 🦀 #rustlang #performance"
  },
  {
    user: all_users[22],
    content: "Viens de publier ma 31ème app sur les stores ! Flutter me permet d'être hyper productif 💙 #flutter #mobile"
  },
  {
    user: all_users[23],
    content: "Animation terminée pour un client après 3 jours de travail. After Effects + créativité = magie ✨ #motion #animation"
  },
  {
    user: all_users[24],
    content: "Multi-cloud c'est le futur ! AWS + GCP + Azure dans la même infra. Terraform fait tout le boulot ☁️ #cloud #devops"
  },
  {
    user: all_users[25],
    content: "Pipeline de données qui traite 10TB par jour. Apache Spark est une vraie bête de course 🚀 #data #bigdata"
  },
  {
    user: all_users[26],
    content: "tRPC + Next.js = le combo parfait pour du full-stack typesafe. Plus jamais de bug de typage entre front et back! #typescript #nextjs"
  },
  {
    user: all_users[27],
    content: "5 sessions de tests utilisateurs cette semaine. Les insights sont incroyables ! Le design sans recherche utilisateur c'est juste deviner 🔍 #ux #research"
  },
  {
    user: all_users[28],
    content: "Trouvé 12 vulnérabilités critiques aujourd'hui. La sécurité web c'est pas optionnel les amis 🛡️ #security #bugbounty"
  },
  {
    user: all_users[29],
    content: "L'accessibilité c'est pour tout le monde ! Nos composants WCAG AAA sont enfin prêts. Le web doit être inclusif ♿ #a11y #accessibility"
  },
  {
    user: all_users[30],
    content: "Phoenix Channels = 2 millions de connexions WebSocket simultanées sur un seul serveur. Elixir est magique 💜 #elixir #realtime"
  },
  {
    user: all_users[31],
    content: "Cypress + Playwright = meilleur combo pour tester. Code coverage à 95% sur notre dernier projet ✅ #testing #qa"
  },
  {
    user: all_users[32],
    content: "Mon jardin est maintenant automatique grâce à l'IoT ! Arduino + capteurs + MQTT = bonheur 🌱🤖 #iot #maker"
  },
  {
    user: all_users[33],
    content: "Première réunion d'équipe aujourd'hui en tant que PM. Excitée de guider ce produit vers le succès ! 📊 #productmanagement"
  },
  {
    user: all_users[34],
    content: "Mon premier bug fix accepté en open source ! Petit mais fier 💪 #junior #opensource"
  },
  {
    user: all_users[35],
    content: "Astro + Tailwind = combo parfait pour un blog performant. Lighthouse score 100/100 sur toutes les métriques! 🚀 #astro #performance"
  },
  {
    user: all_users[0],
    content: "Après 6 mois de développement, NexP atteint 1000 projets créés ! Merci à toute la communauté 🎉 #milestone #nexp"
  },
  {
    user: all_users[5],
    content: "Code review de la semaine : les microservices c'est bien, mais commencez par un monolithe bien architecturé ! #architecture #golang"
  },
  {
    user: all_users[8],
    content: "Design system mis à jour avec 50 nouveaux composants. La cohérence visuelle c'est la clé 🎨 #designsystem #figma"
  },
  {
    user: all_users[12],
    content: "Notre modèle RAG atteint maintenant 98% de précision. GPT-4 + embeddings + vector DB = combo gagnant 🤖 #ai #rag"
  },
  {
    user: all_users[14],
    content: "Zero-downtime deployment réussi avec Kubernetes. Blue-green deployment FTW! 🔵🟢 #kubernetes #devops"
  },
  {
    user: all_users[4],
    content: "Node.js 22 est sorti avec des perf incroyables ! Le backend JavaScript n'a jamais été aussi rapide ⚡ #nodejs #backend"
  },
  {
    user: all_users[10],
    content: "React Native 0.75 change vraiment la donne. Le New Architecture est enfin stable ! #reactnative #mobile"
  },
  {
    user: all_users[1],
    content: "Framer Motion + React = animations butter smooth. L'UI prend vraiment vie ! #frontend #react #animation"
  },
  {
    user: all_users[19],
    content: "Notre collection NFT est soldout en 2 heures ! La communauté Web3 est incroyable 🔥 #web3 #nft"
  },
  {
    user: all_users[15],
    content: "Sprint retro done! L'équipe a livré 100% des user stories. Fiers de cette vélocité 🚀 #agile #scrum"
  },
  {
    user: all_users[18],
    content: "10 ans de freelance aujourd'hui ! Merci à tous mes clients qui m'ont fait confiance 🙏 #freelance #milestone"
  },
  {
    user: all_users[7],
    content: "Vue 3 Composition API > Options API. Fight me! 😄 Mais sérieusement, c'est tellement mieux #vuejs #frontend"
  },
  {
    user: all_users[11],
    content: "SwiftUI continue de s'améliorer. Développer des apps iOS natives n'a jamais été aussi agréable 🍎 #swift #ios"
  },
  {
    user: all_users[3],
    content: "Laravel 11 est une tuerie ! Les performances sont incroyables et le DX est au top #laravel #php"
  },
  {
    user: all_users[13],
    content: "Notebook Jupyter qui tourne dans le cloud. Analyser 1TB de données sans soucis 📊 #datascience #jupyter"
  },
  {
    user: all_users[16],
    content: "3 mois de coding bootcamp terminés ! Prêt à rejoindre ma première équipe 💻 #junior #bootcamp"
  },
  {
    user: all_users[20],
    content: "Update du jeu : le système de combat multijoueur fonctionne ! 100 joueurs simultanés sans lag 🎮 #gamedev #multiplayer"
  },
  {
    user: all_users[2],
    content: "Python 3.13 est encore plus rapide ! Le typage statique avec mypy rend le code tellement plus robuste 🐍 #python"
  },
  {
    user: all_users[9],
    content: "Prototypage terminé en 2 jours grâce à Figma Auto Layout. Les devs vont être contents 😊 #figma #design"
  },
  {
    user: all_users[6],
    content: "TIL: Les view transitions API sont natives dans tous les browsers maintenant. Plus besoin de lib! 🤯 #frontend #webdev"
  },
  {
    user: all_users[21],
    content: "WebAssembly + Rust = performance native dans le browser. Le futur du web est déjà là! 🚀 #wasm #rust"
  },
  {
    user: all_users[26],
    content: "Next.js App Router + Server Components = game changer. Les temps de chargement sont divisés par 3! ⚡ #nextjs #react"
  },
  {
    user: all_users[28],
    content: "Pénétration test terminé : 0 vulnérabilités critiques trouvées ! L'équipe a fait un super boulot 🛡️ #security #pentest"
  },
  {
    user: all_users[25],
    content: "ETL pipeline qui process 50M de lignes en 10 minutes. Spark + optimisations = magie 📊 #dataengineering #spark"
  },
  {
    user: all_users[27],
    content: "Les tests A/B confirment notre nouvelle UI : +40% de conversion ! Data-driven design pour la win 📈 #ux #testing"
  },
  {
    user: all_users[30],
    content: "Functional programming change vraiment la façon de penser. Pattern matching + immutabilité = moins de bugs 💜 #elixir #functional"
  },
  {
    user: all_users[24],
    content: "Infrastructure as Code saved us 20h/week. Terraform + Ansible = automation parfaite ⚙️ #devops #iac"
  }
]

all_posts = []
posts_data.each do |post_data|
  post = Post.create!(
    user: post_data[:user],
    content: post_data[:content],
    created_at: rand(1..14).days.ago
  )
  all_posts << post
end

puts "✅ #{Post.count} posts créés"

# ========================================
# 7️⃣ LIKES - Interactions
# ========================================

# Générer des likes aléatoires
like_count = 0
all_posts.each do |post|
  # Chaque post reçoit entre 5 et 25 likes (plus d'engagement)
  # Les posts des utilisateurs de haut niveau reçoivent plus de likes
  max_likes = post.user.level > 10 ? 25 : (post.user.level > 5 ? 20 : 15)
  min_likes = post.user.level > 10 ? 10 : (post.user.level > 5 ? 5 : 3)

  likers = all_users.sample(rand(min_likes..max_likes))
  likers.each do |user|
    next if user == post.user # On ne like pas son propre post

    begin
      Like.create!(user: user, post: post, created_at: post.created_at + rand(1..48).hours)
      like_count += 1
    rescue ActiveRecord::RecordInvalid
      # Skip si déjà liké
    end
  end
end

puts "✅ #{like_count} likes créés"

# ========================================
# 8️⃣ MESSAGES - Communications projet
# ========================================

messages_data = [
  # Messages projet NexP
  { sender: all_users[0], project: all_projects[0], content: "Hey team ! Bienvenue sur NexP 🎉 Super content de vous avoir avec nous !", created_at: 2.months.ago },
  { sender: all_users[1], project: all_projects[0], content: "Merci Greg ! Hâte de commencer. On commence par quoi ?", created_at: 2.months.ago + 2.hours },
  { sender: all_users[0], project: all_projects[0], content: "Je propose qu'on setup le projet Rails aujourd'hui et que Sarah commence sur le design du dashboard", created_at: 2.months.ago + 3.hours },
  { sender: all_users[8], project: all_projects[0], content: "Perfect ! Je vais créer les wireframes ce week-end", created_at: 2.months.ago + 5.hours },
  { sender: all_users[14], project: all_projects[0], content: "Je m'occupe du Docker Compose et de la CI/CD 👍", created_at: 2.months.ago + 1.day },
  { sender: all_users[0], project: all_projects[0], content: "Update: l'authentification est prête ! Sarah tu peux commencer l'intégration", created_at: 1.month.ago },
  { sender: all_users[1], project: all_projects[0], content: "Nickel ! Je regarde ça aujourd'hui", created_at: 1.month.ago + 2.hours },

  # Messages projet TaskFlow
  { sender: all_users[1], project: all_projects[1], content: "Salut l'équipe ! Qui veut s'occuper du drag & drop des cards ?", created_at: 3.weeks.ago },
  { sender: all_users[4], project: all_projects[1], content: "Je peux faire ça ! J'ai déjà utilisé react-beautiful-dnd", created_at: 3.weeks.ago + 1.hour },
  { sender: all_users[6], project: all_projects[1], content: "Parfait ! Moi je vais bosser sur les animations de transition", created_at: 3.weeks.ago + 3.hours },

  # Messages projet FitBuddy
  { sender: all_users[10], project: all_projects[4], content: "Le tracking GPS est opérationnel ! 🏃‍♂️", created_at: 2.weeks.ago },
  { sender: all_users[12], project: all_projects[4], content: "Super ! Le modèle ML pour les recommandations est presque prêt", created_at: 2.weeks.ago + 5.hours },
  { sender: all_users[9], project: all_projects[4], content: "J'ai terminé les écrans de workout. Je vous envoie le Figma", created_at: 2.weeks.ago + 1.day },

  # Messages projet DocuMind
  { sender: all_users[12], project: all_projects[6], content: "La V1 du RAG est en prod ! Testez avec vos propres docs", created_at: 1.week.ago },
  { sender: all_users[13], project: all_projects[6], content: "Wow c'est impressionnant ! La précision est top", created_at: 1.week.ago + 4.hours },

  # Messages projet LocalMarket
  { sender: all_users[4], project: all_projects[8], content: "Meeting demain 14h pour faire le point sur le sprint ?", created_at: 5.days.ago },
  { sender: all_users[1], project: all_projects[8], content: "Ok pour moi ! Je prépare une démo du panier", created_at: 5.days.ago + 1.hour },
  { sender: all_users[10], project: all_projects[8], content: "Validé. L'app mobile est prête aussi", created_at: 5.days.ago + 2.hours },

  # Messages projet CodeReview.ai
  { sender: all_users[5], project: all_projects[9], content: "L'API Go est déployée et stable ! 🚀", created_at: 3.days.ago },
  { sender: all_users[0], project: all_projects[9], content: "Excellent ! J'ai testé et c'est vraiment rapide", created_at: 3.days.ago + 3.hours },

  # Messages projet PixelQuest
  { sender: all_users[20], project: all_projects[14], content: "Le monde procédural est incroyable ! 🎮", created_at: 2.days.ago },
  { sender: all_users[9], project: all_projects[14], content: "J'ai terminé les UI des inventaires. C'est pixel perfect ✨", created_at: 2.days.ago + 4.hours },

  # Messages RustCache
  { sender: all_users[21], project: all_projects[20], content: "Hello team! Le repo est prêt, on commence par l'architecture de base ?", created_at: 3.weeks.ago },
  { sender: all_users[5], project: all_projects[20], content: "Parfait ! Je propose qu'on use Tokio pour l'async runtime", created_at: 3.weeks.ago + 2.hours },
  { sender: all_users[14], project: all_projects[20], content: "Je setup le CI/CD sur GitHub Actions ce week-end", created_at: 3.weeks.ago + 1.day },
  { sender: all_users[21], project: all_projects[20], content: "Update: le protocole Redis est compatible à 80% ! Les tests passent 🎉", created_at: 1.week.ago },

  # Messages TravelMate
  { sender: all_users[22], project: all_projects[21], content: "Salut ! Super excité de travailler sur ce projet de voyage", created_at: 1.month.ago },
  { sender: all_users[9], project: all_projects[21], content: "Moi aussi ! J'ai déjà quelques idées de design. Je vous montre ça demain", created_at: 1.month.ago + 3.hours },
  { sender: all_users[12], project: all_projects[21], content: "Pour les recommandations AI, je pense utiliser un modèle de collaborative filtering", created_at: 1.month.ago + 1.day },
  { sender: all_users[22], project: all_projects[21], content: "La carte interactive est fonctionnelle ! Qui veut tester ?", created_at: 2.weeks.ago },
  { sender: all_users[9], project: all_projects[21], content: "Je teste maintenant ! L'UX a l'air super smooth", created_at: 2.weeks.ago + 2.hours },

  # Messages CloudCost
  { sender: all_users[24], project: all_projects[22], content: "Bienvenue à tous ! C'est parti pour optimiser les coûts cloud ☁️", created_at: 2.months.ago },
  { sender: all_users[0], project: all_projects[22], content: "Super projet Romain ! Content d'être advisor", created_at: 2.months.ago + 4.hours },
  { sender: all_users[14], project: all_projects[22], content: "J'ai de l'expérience avec les 3 clouds, je peux aider sur l'archi", created_at: 2.months.ago + 1.day },
  { sender: all_users[5], project: all_projects[22], content: "L'API Go est prête, on peut commencer l'intégration AWS", created_at: 1.month.ago },
  { sender: all_users[6], project: all_projects[22], content: "Le dashboard React affiche les premières métriques ! 📊", created_at: 3.weeks.ago },
  { sender: all_users[24], project: all_projects[22], content: "Excellent travail team ! On est dans les temps", created_at: 2.weeks.ago },

  # Messages FormCraft
  { sender: all_users[26], project: all_projects[24], content: "Let's build the best form builder ever! 🚀", created_at: 2.weeks.ago },
  { sender: all_users[6], project: all_projects[24], content: "J'adore le concept ! tRPC va rendre le dev tellement agréable", created_at: 2.weeks.ago + 3.hours },
  { sender: all_users[8], project: all_projects[24], content: "Je commence les wireframes de l'éditeur visuel", created_at: 2.weeks.ago + 1.day },
  { sender: all_users[26], project: all_projects[24], content: "Le drag & drop fonctionne ! Vous pouvez tester sur staging", created_at: 5.days.ago },

  # Messages SecureCheck
  { sender: all_users[28], project: all_projects[26], content: "Security first! Commençons par les tests OWASP Top 10", created_at: 1.month.ago },
  { sender: all_users[5], project: all_projects[26], content: "D'accord, je m'occupe de l'API backend en Go", created_at: 1.month.ago + 2.hours },
  { sender: all_users[31], project: all_projects[26], content: "Je vais créer une suite de tests pour valider les scans", created_at: 1.month.ago + 1.day },
  { sender: all_users[28], project: all_projects[26], content: "Premier scan réussi ! On détecte déjà 15 types de vulnérabilités", created_at: 2.weeks.ago },
  { sender: all_users[31], project: all_projects[26], content: "Les tests automatisés sont en place. Code coverage à 85%", created_at: 1.week.ago },

  # Messages ChatStream
  { sender: all_users[30], project: all_projects[28], content: "Phoenix Channels time! Prêts à scaler à 1M de connexions?", created_at: 3.weeks.ago },
  { sender: all_users[4], project: all_projects[28], content: "Impressionnant ! Je n'ai jamais travaillé avec Elixir mais j'ai hâte d'apprendre", created_at: 3.weeks.ago + 3.hours },
  { sender: all_users[1], project: all_projects[28], content: "Je m'occupe du client React avec Socket.io", created_at: 3.weeks.ago + 1.day },
  { sender: all_users[30], project: all_projects[28], content: "Update: 500k connexions simultanées en test. Aucun lag 🔥", created_at: 1.week.ago },
  { sender: all_users[1], project: all_projects[28], content: "Le typing indicator fonctionne parfaitement !", created_at: 1.week.ago + 4.hours },

  # Messages SmartGarden
  { sender: all_users[32], project: all_projects[30], content: "Salut team! J'ai reçu les capteurs Arduino, on peut commencer 🌱", created_at: 2.weeks.ago },
  { sender: all_users[34], project: all_projects[30], content: "Cool ! C'est mon premier projet IoT, je vais apprendre plein de choses", created_at: 2.weeks.ago + 2.hours },
  { sender: all_users[7], project: all_projects[30], content: "Je vais créer l'interface web pour monitorer les plantes", created_at: 2.weeks.ago + 1.day },
  { sender: all_users[32], project: all_projects[30], content: "Les capteurs d'humidité sont calibrés ! Données en temps réel via MQTT", created_at: 4.days.ago },
  { sender: all_users[7], project: all_projects[30], content: "Dashboard terminé ! On voit tout en temps réel 📊", created_at: 3.days.ago },

  # Messages RecipeBox
  { sender: all_users[34], project: all_projects[31], content: "Mon premier vrai projet ! Qui veut m'aider à apprendre ?", created_at: 1.week.ago },
  { sender: all_users[16], project: all_projects[31], content: "Moi aussi je suis junior, on va apprendre ensemble ! 💪", created_at: 1.week.ago + 1.hour },
  { sender: all_users[34], project: all_projects[31], content: "J'ai réussi à faire le CRUD des recettes ! Trop content", created_at: 3.days.ago },
  { sender: all_users[16], project: all_projects[31], content: "Bravo ! Je travaille sur l'upload des photos", created_at: 3.days.ago + 2.hours },

  # Messages TechBlog
  { sender: all_users[35], project: all_projects[32], content: "Astro c'est trop cool ! Le blog charge en 0.5s", created_at: 1.week.ago },
  { sender: all_users[2], project: all_projects[32], content: "Super ! J'ai commencé à écrire les premiers articles techniques", created_at: 1.week.ago + 3.hours },
  { sender: all_users[35], project: all_projects[32], content: "Score Lighthouse 100/100 ! 🎉", created_at: 2.days.ago },

  # Plus de messages sur projets existants
  { sender: all_users[1], project: all_projects[0], content: "Les animations du dashboard sont terminées ! C'est smooth 😎", created_at: 3.days.ago },
  { sender: all_users[8], project: all_projects[0], content: "Le nouveau design est validé ! Je prépare les composants Figma", created_at: 3.days.ago + 2.hours },
  { sender: all_users[26], project: all_projects[1], content: "Je peux aider sur le backend si besoin ?", created_at: 1.week.ago },
  { sender: all_users[1], project: all_projects[1], content: "Oui super ! On a besoin d'aide sur l'API", created_at: 1.week.ago + 1.hour },
  { sender: all_users[35], project: all_projects[2], content: "SEO optimization done! On devrait bien ranker maintenant", created_at: 5.days.ago },
  { sender: all_users[25], project: all_projects[6], content: "La pipeline de données est prête pour traiter les documents", created_at: 4.days.ago },
  { sender: all_users[12], project: all_projects[6], content: "Parfait ! On peut augmenter le volume maintenant", created_at: 4.days.ago + 3.hours },
  { sender: all_users[27], project: all_projects[8], content: "J'ai des retours utilisateurs très positifs sur l'UX!", created_at: 6.days.ago },
  { sender: all_users[21], project: all_projects[9], content: "J'ai optimisé les perfs, c'est 3x plus rapide maintenant", created_at: 2.days.ago },
  { sender: all_users[31], project: all_projects[9], content: "Tous les tests E2E passent ! 95% coverage", created_at: 1.day.ago }
]

messages_data.each do |msg_data|
  Message.create!(
    sender: msg_data[:sender],
    project: msg_data[:project],
    content: msg_data[:content],
    created_at: msg_data[:created_at]
  )
end

puts "✅ #{Message.count} messages créés"

# ========================================
# 📊 RÉSUMÉ FINAL
# ========================================

puts "\n" + "="*60
puts "🎉 SEED COMPLÈTE TERMINÉE !"
puts "="*60
puts "👥 Utilisateurs        : #{User.count}"
puts "   - Niveaux 1-5       : #{User.where(level: 1..5).count}"
puts "   - Niveaux 6-10      : #{User.where(level: 6..10).count}"
puts "   - Niveaux 11+       : #{User.where(level: 11..20).count}"
puts "   - Disponibles       : #{User.where(available: true).count}"
puts ""
puts "⚡ Skills              : #{Skill.count}"
puts "   - Catégories        : #{Skill.distinct.count(:category)}"
puts ""
puts "🚀 Projets             : #{Project.count}"
puts "   - En cours          : #{Project.where(status: 'in_progress').count}"
puts "   - Ouverts           : #{Project.where(status: 'open').count}"
puts "   - Complétés         : #{Project.where(status: 'completed').count}"
puts ""
puts "👥 Teams               : #{Team.count}"
puts "   - Acceptés          : #{Team.where(status: 'accepted').count}"
puts "   - En attente        : #{Team.where(status: 'pending').count}"
puts ""
puts "🏆 Badges              : #{Badge.count}"
puts "   - Obtenus           : #{UserBadge.count}"
puts ""
puts "💬 Posts               : #{Post.count}"
puts "❤️  Likes               : #{Like.count}"
puts "📨 Messages            : #{Message.count}"
puts "="*60
puts "\n✅ Connexion test: greg@nexp.dev / azerty"
puts "="*60
