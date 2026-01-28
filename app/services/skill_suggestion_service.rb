# frozen_string_literal: true

class SkillSuggestionService
  # Mapping des abbreviations courantes vers les noms complets
  ABBREVIATION_MAP = {
    # Langages
    'js' => 'JavaScript',
    'ts' => 'TypeScript',
    'py' => 'Python',
    'rb' => 'Ruby',
    'go' => 'Go',
    'golang' => 'Go',
    'rs' => 'Rust',
    'cs' => 'C#',
    'cpp' => 'C++',
    'kt' => 'Kotlin',

    # Frameworks
    'ror' => 'Ruby on Rails',
    'rails' => 'Ruby on Rails',
    'rn' => 'React Native',
    'vue' => 'Vue.js',
    'ng' => 'Angular',
    'angular' => 'Angular',
    'next' => 'Next.js',
    'nuxt' => 'Nuxt.js',
    'node' => 'Node.js',
    'express' => 'Express.js',
    'dj' => 'Django',
    'fastapi' => 'FastAPI',

    # Databases
    'pg' => 'PostgreSQL',
    'postgres' => 'PostgreSQL',
    'mysql' => 'MySQL',
    'mongo' => 'MongoDB',
    'redis' => 'Redis',
    'elastic' => 'Elasticsearch',
    'es' => 'Elasticsearch',

    # DevOps
    'k8s' => 'Kubernetes',
    'tf' => 'Terraform',
    'aws' => 'AWS',
    'gcp' => 'GCP',
    'az' => 'Azure',
    'docker' => 'Docker',
    'ci' => 'CI/CD',
    'cicd' => 'CI/CD',

    # IA & Data
    'ml' => 'Machine Learning',
    'ai' => 'Machine Learning',
    'ia' => 'Machine Learning',
    'dl' => 'Deep Learning',
    'nlp' => 'NLP',
    'cv' => 'Computer Vision',
    'llm' => 'LangChain',

    # Design
    'ui' => 'UI/UX Design',
    'ux' => 'UI/UX Design',
    'figma' => 'Figma',

    # Autres
    'graphql' => 'GraphQL',
    'gql' => 'GraphQL',
    'rest' => 'API REST',
    'api' => 'API REST',
    'git' => 'Git',
    'gh' => 'GitHub',
    'tw' => 'Tailwind CSS',
    'tailwind' => 'Tailwind CSS',
    'sass' => 'SASS',
    'scss' => 'SASS'
  }.freeze

  # Mots-cles qui indiquent une intention de categorie
  CATEGORY_KEYWORDS = {
    'Backend' => %w[backend back-end server serveur api back],
    'Frontend' => %w[frontend front-end ui interface web front html css],
    'Mobile' => %w[mobile ios android app application],
    'Database' => %w[database db bdd data donnees sql nosql],
    'DevOps' => %w[devops ops ci cd deploy infrastructure cloud],
    'IA & Data' => %w[ai ia ml data machine learning intelligence analytics],
    'Design' => %w[design ui ux figma graphique visual],
    'Product & Business' => %w[product business produit agile scrum pm],
    'Security' => %w[security securite auth crypto owasp],
    'Testing & QA' => %w[test testing qa quality tdd spec],
    'Blockchain' => %w[blockchain crypto web3 smart contract nft defi],
    'Game Dev' => %w[game jeu unity unreal gaming],
    'Tools' => %w[tool outil desktop electron],
    'Autre' => %w[other autre misc]
  }.freeze

  # Definitions des tech stacks pour "Complete ta stack"
  TECH_STACKS = {
    'rails_fullstack' => {
      core: ['Ruby on Rails', 'Ruby', 'PostgreSQL'],
      recommended: ['Stimulus', 'Turbo', 'Hotwire', 'Redis', 'Sidekiq', 'RSpec', 'Tailwind CSS']
    },
    'react_fullstack' => {
      core: ['React', 'JavaScript', 'Node.js'],
      recommended: ['TypeScript', 'Next.js', 'Redux', 'Tailwind CSS', 'Express.js', 'MongoDB']
    },
    'vue_fullstack' => {
      core: ['Vue.js', 'JavaScript'],
      recommended: ['Nuxt.js', 'TypeScript', 'Pinia', 'Tailwind CSS', 'Node.js']
    },
    'python_data' => {
      core: ['Python', 'Pandas', 'NumPy'],
      recommended: ['Machine Learning', 'scikit-learn', 'TensorFlow', 'PyTorch', 'Jupyter', 'SQL']
    },
    'mobile_react_native' => {
      core: ['React Native', 'JavaScript'],
      recommended: ['TypeScript', 'Expo', 'Redux', 'React', 'Firebase']
    },
    'mobile_flutter' => {
      core: ['Flutter', 'Dart'],
      recommended: ['Firebase', 'Supabase', 'API REST']
    },
    'devops_cloud' => {
      core: ['Docker', 'Kubernetes', 'Linux'],
      recommended: ['Terraform', 'AWS', 'CI/CD', 'Monitoring', 'Nginx', 'Bash']
    }
  }.freeze

  def initialize(user)
    @user = user
    @user_skill_ids = user&.skills&.pluck(:id) || []
    @user_skill_names = user&.skills&.pluck(:name) || []
    # Utiliser reorder pour eviter le conflit avec default_scope
    @user_categories = user&.skills&.reorder('')&.distinct&.pluck(:category) || []
  end

  # Point d'entree principal pour la recherche intelligente
  def search(query, limit: 20)
    return Skill.none if query.blank?

    normalized_query = normalize_query(query)

    # Detecter si la query correspond a une categorie
    category_match = detect_category_intent(normalized_query)

    # Expander la query avec abbreviations
    expanded_terms = expand_query(normalized_query)

    # Construire les resultats de recherche
    results = build_search_results(expanded_terms, category_match, limit)

    # Scorer et trier les resultats
    score_and_sort_results(results, normalized_query)
  end

  # Obtenir toutes les suggestions pour l'utilisateur
  def get_all_suggestions
    {
      based_on_skills: based_on_your_skills(limit: 6),
      complete_your_stack: complete_your_stack(limit: 6),
      popular_in_category: popular_in_your_category(limit: 6),
      trending_now: trending_now(limit: 6)
    }
  end

  # Suggestion 1: Base sur tes skills (co-occurrence)
  def based_on_your_skills(limit: 5)
    return [] if @user_skill_ids.empty?

    Skill.commonly_paired_with(@user_skill_ids, limit: limit * 2)
         .where.not(id: @user_skill_ids)
         .limit(limit)
         .map { |skill| { skill: skill, reason: 'commonly_paired' } }
  end

  # Suggestion 2: Populaire dans ta categorie principale
  def popular_in_your_category(limit: 5)
    return [] if @user_categories.empty?

    # Trouver la categorie principale de l'utilisateur (reorder pour eviter conflit default_scope)
    primary_category = @user.skills
                            .reorder('')
                            .group(:category)
                            .count
                            .max_by { |_, count| count }
                            &.first

    return [] unless primary_category

    Skill.where(category: primary_category)
         .where.not(id: @user_skill_ids)
         .order(users_count: :desc)
         .limit(limit)
         .map { |skill| { skill: skill, reason: 'popular_in_category', category: primary_category } }
  end

  # Suggestion 3: Complete ta stack
  def complete_your_stack(limit: 5)
    return [] if @user_skill_names.empty?

    missing_skills = []

    TECH_STACKS.each do |stack_name, stack|
      # Verifier si l'utilisateur a les skills core de cette stack
      core_match = (stack[:core] & @user_skill_names).size
      core_coverage = core_match.to_f / stack[:core].size

      next unless core_coverage >= 0.5 # Au moins 50% des skills core

      # Trouver les skills recommandees manquantes
      missing_recommended = stack[:recommended] - @user_skill_names

      missing_recommended.each do |skill_name|
        skill = Skill.find_by(name: skill_name)
        next unless skill && !@user_skill_ids.include?(skill.id)

        missing_skills << {
          skill: skill,
          reason: 'complete_stack',
          stack: stack_name.humanize
        }
      end
    end

    missing_skills.uniq { |s| s[:skill].id }.first(limit)
  end

  # Suggestion 4: Tendances globales
  def trending_now(limit: 5)
    # Skills avec le plus d'ajouts ces 30 derniers jours (unscoped pour eviter default_scope)
    trending_skill_ids = UserSkill.unscoped
                                   .where('created_at > ?', 30.days.ago)
                                   .group(:skill_id)
                                   .order(Arel.sql('COUNT(*) DESC'))
                                   .limit(limit * 2)
                                   .pluck(:skill_id)

    return [] if trending_skill_ids.empty?

    Skill.where(id: trending_skill_ids)
         .where.not(id: @user_skill_ids)
         .order(Arel.sql("ARRAY_POSITION(ARRAY[#{trending_skill_ids.join(',')}]::bigint[], skills.id)"))
         .limit(limit)
         .map { |skill| { skill: skill, reason: 'trending' } }
  end

  private

  def normalize_query(query)
    query.to_s.strip.downcase.gsub(/[^\w\s\-\.\/\+#]/, '')
  end

  def detect_category_intent(query)
    CATEGORY_KEYWORDS.each do |category, keywords|
      return category if keywords.any? { |kw| query.include?(kw) }
    end
    nil
  end

  def expand_query(query)
    terms = [query]

    # Ajouter l'expansion d'abbreviation
    if ABBREVIATION_MAP.key?(query)
      terms << ABBREVIATION_MAP[query].downcase
    end

    # Chercher aussi dans les valeurs (reverse lookup)
    ABBREVIATION_MAP.each do |abbrev, full_name|
      if full_name.downcase.include?(query)
        terms << abbrev
        terms << full_name.downcase
      end
    end

    terms.uniq
  end

  def build_search_results(expanded_terms, category_match, limit)
    results = []

    # 1. Correspondances exactes (priorite haute)
    exact_matches = Skill.where('LOWER(name) = ANY(ARRAY[?])', expanded_terms)
    results.concat(exact_matches.to_a)

    # 2. Correspondances par prefix
    pattern = expanded_terms.first
    prefix_matches = Skill.where("LOWER(name) LIKE ?", "#{pattern}%")
                          .where.not(id: results.map(&:id))
    results.concat(prefix_matches.to_a)

    # 3. Correspondances contenant le terme
    contains_matches = Skill.where("LOWER(name) LIKE ?", "%#{pattern}%")
                            .where.not(id: results.map(&:id))
    results.concat(contains_matches.to_a)

    # 4. Fuzzy matching avec pg_trgm
    begin
      fuzzy_matches = Skill.where("name % ?", pattern)
                           .where.not(id: results.map(&:id))
                           .order(Arel.sql("similarity(name, #{Skill.connection.quote(pattern)}) DESC"))
                           .limit(10)
      results.concat(fuzzy_matches.to_a)
    rescue StandardError
      # pg_trgm pas disponible, ignorer
    end

    # 5. Si categorie detectee, ajouter les skills de cette categorie
    if category_match
      category_skills = Skill.where(category: category_match)
                             .where.not(id: results.map(&:id))
                             .order(users_count: :desc)
                             .limit(20)
      results.concat(category_skills.to_a)
    end

    results.uniq.first(limit)
  end

  def score_and_sort_results(results, query)
    scored = results.map do |skill|
      score = calculate_relevance_score(skill, query)
      { skill: skill, score: score }
    end

    scored.sort_by { |r| -r[:score] }.map { |r| r[:skill] }
  end

  def calculate_relevance_score(skill, query)
    score = 0.0
    skill_name_lower = skill.name.downcase

    # 1. Match textuel (0-100 points)
    # Abbreviation directe a la priorite la plus haute (presque comme match exact)
    if ABBREVIATION_MAP[query]&.downcase == skill_name_lower
      score += 95  # "js" → "JavaScript" = 95 pts
    elsif skill_name_lower == query
      score += 100
    elsif skill_name_lower.start_with?(query)
      score += 80
    elsif skill_name_lower.include?(query)
      score += 60  # "Node.js" contient "js" = 60 pts
    else
      # Fuzzy match
      score += 40
    end

    # 2. Popularite (0-20 points)
    score += [skill.users_count.to_f / 10, 20].min

    # 3. Pertinence contextuelle (0-25 points)
    if @user_categories.include?(skill.category)
      score += 15
    end

    # 4. Co-occurrence avec les skills de l'utilisateur
    if @user_skill_ids.any? && Skill.commonly_paired_with(@user_skill_ids).exists?(id: skill.id)
      score += 10
    end

    # 5. Penalite si l'utilisateur a deja cette skill
    score -= 1000 if @user_skill_ids.include?(skill.id)

    score
  end
end
