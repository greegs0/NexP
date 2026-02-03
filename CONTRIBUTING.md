# Guide de Contribution - NexP

Merci de vouloir contribuer à NexP ! Ce document décrit les conventions et processus à suivre.

## Table des Matières

- [Code de Conduite](#code-de-conduite)
- [Getting Started](#getting-started)
- [Conventions de Code](#conventions-de-code)
- [Process de Pull Request](#process-de-pull-request)
- [Tests](#tests)
- [Commits](#commits)

## Code de Conduite

Ce projet adhère à un code de conduite professionnel. Soyez respectueux et constructif dans toutes vos interactions.

## Getting Started

### Prérequis

- Ruby 3.3.5
- PostgreSQL 17
- Node.js 20+
- Redis 8.4+ (requis pour cache, Sidekiq, et Action Cable)

### Installation

```bash
# Cloner le repo
git clone https://github.com/greegs0/NexP.git
cd NexP

# Installer les dépendances
bundle install

# Configurer la base de données
bin/rails db:setup

# Lancer les tests
bundle exec rspec

# Démarrer le serveur
bin/dev
```

## Conventions de Code

### Ruby / Rails

- **Style**: Suivre les conventions Ruby standard (voir `.rubocop.yml`)
- **Indentation**: 2 espaces
- **Longueur de ligne**: Max 120 caractères
- **Nommage**:
  - Classes/Modules: `CamelCase`
  - Méthodes/Variables: `snake_case`
  - Constantes: `SCREAMING_SNAKE_CASE`

### Services

Placer la logique métier dans des services (`app/services/`):

```ruby
class MyService
  def initialize(user)
    @user = user
  end

  def call
    # Logique métier
  end
end
```

### Controllers

- Garder les controllers légers (<100 lignes)
- Utiliser les concerns pour la logique réutilisable
- Utiliser les services pour la logique métier complexe

### JavaScript

- Utiliser Stimulus pour les interactions UI
- Pas de `console.log` en production
- Nommer les controllers en `kebab-case`

### Views

- Extraire les éléments répétés dans des partials
- Utiliser les helpers pour la logique de présentation
- **Ne jamais utiliser `html_safe` directement** - utiliser `sanitize()` ou des helpers dédiés

## Process de Pull Request

### 1. Créer une branche

```bash
git checkout -b feature/ma-fonctionnalite
# ou
git checkout -b fix/mon-bug-fix
```

### 2. Développer

- Écrire du code propre et testé
- Suivre les conventions ci-dessus
- Mettre à jour la documentation si nécessaire

### 3. Tester

```bash
# Lancer tous les tests
bundle exec rspec

# Lancer les tests d'un fichier spécifique
bundle exec rspec spec/services/mon_service_spec.rb

# Vérifier le style
bundle exec rubocop
```

### 4. Commit

Voir la section [Commits](#commits) ci-dessous.

### 5. Push et PR

```bash
git push origin feature/ma-fonctionnalite
```

Créer une Pull Request via GitHub avec:
- Titre clair et descriptif
- Description de ce qui a changé et pourquoi
- Référence aux issues liées (si applicable)

## Tests

### Structure

```
spec/
├── factories/      # FactoryBot factories
├── models/         # Tests des models
├── requests/       # Tests des controllers (request specs)
├── services/       # Tests des services
├── channels/       # Tests ActionCable
└── support/        # Helpers et configuration
```

### Écrire des Tests

- Chaque fonctionnalité doit avoir des tests
- Utiliser FactoryBot pour les données de test
- Préférer les request specs aux controller specs
- Viser une couverture >80% sur les services

### Exemple

```ruby
RSpec.describe MyService, type: :service do
  let(:user) { create(:user) }

  describe '#call' do
    it 'performs the expected action' do
      result = described_class.new(user).call
      expect(result).to be_success
    end
  end
end
```

## Commits

### Format du Message

```
type(scope): description courte

Description plus longue si nécessaire.
Expliquer le "pourquoi" plutôt que le "quoi".

Fixes #123
```

### Types

- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation uniquement
- `style`: Formatage (pas de changement de logique)
- `refactor`: Refactoring sans changement de comportement
- `test`: Ajout ou modification de tests
- `chore`: Maintenance (dépendances, config, etc.)

### Exemples

```
feat(badges): add badge modal with details

fix(auth): handle expired JWT tokens gracefully

docs(readme): update installation instructions

refactor(services): extract XP calculation to ExperienceService
```

## Questions ?

Si vous avez des questions, ouvrez une issue sur GitHub ou contactez les mainteneurs.

---

Merci de contribuer à NexP !
