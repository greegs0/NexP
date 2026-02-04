# db/seeds/skills.rb
# Skills de référence pour NexP

SKILLS_DATA = {
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
}.freeze

def seed_skills
  puts "Création des skills..."

  all_skills = {}
  SKILLS_DATA.each do |category, names|
    names.each do |name|
      skill = Skill.find_or_create_by!(name: name) do |s|
        s.category = category
      end
      all_skills[name] = skill
    end
  end

  puts "  #{Skill.count} skills créées dans #{Skill.distinct.count(:category)} catégories"
  all_skills
end
