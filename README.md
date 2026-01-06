<div align="center">

# 🚀 NexP

### Plateforme collaborative nouvelle génération pour développeurs

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.1-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Demo](#) • [Documentation](#) • [Contribuer](#contributing)

</div>

---

## 📋 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Stack technique](#-stack-technique)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Base de données](#-base-de-données)
- [API](#-api)
- [Tests](#-tests)
- [Déploiement](#-déploiement)
- [Contribuer](#-contribuer)
- [Roadmap](#-roadmap)
- [License](#-license)

---

## 🎯 À propos

**NexP** est une plateforme collaborative conçue pour connecter les développeurs autour de projets communs. Elle permet de :

- 🔍 **Découvrir** des projets en fonction de ses compétences
- 🤝 **Collaborer** avec d'autres devs en temps réel
- 📊 **Suivre** l'avancement des projets via un dashboard intuitif
- 🏆 **Gagner** des badges en fonction de vos contributions
- 💬 **Échanger** via un système de messagerie intégré

---

## ✨ Fonctionnalités

### 🚀 MVP (Phase 1)

- [x] Authentification utilisateur (Devise)
- [x] Gestion des profils développeurs
- [x] Système de compétences (skills)
- [x] Création et gestion de projets
- [x] Équipes et collaborations
- [x] Messagerie interne
- [x] Feed social (posts + likes)

### 🔮 Fonctionnalités avancées (Phase 2)

- [ ] Matching automatique projet/développeur (ML)
- [ ] Système de badges et gamification
- [ ] Notifications temps réel (ActionCable)
- [ ] API REST complète
- [ ] Dashboard analytics
- [ ] Intégrations GitHub/GitLab
- [ ] Mode sombre

---

## 🛠 Stack technique

### Backend

| Technologie | Version | Usage |
|------------|---------|-------|
| Ruby | 3.3.6 | Langage principal |
| Rails | 8.0.1 | Framework web |
| PostgreSQL | 17 | Base de données |
| Devise | 4.9 | Authentification |
| Puma | 6.5 | Serveur web |

### Frontend

| Technologie | Version | Usage |
|------------|---------|-------|
| Hotwire | - | Interactivité |
| Stimulus | 3.2 | JavaScript framework |
| Tailwind CSS | 3.4 | Styling |
| ImportMap | - | Gestion JS |

### DevOps

- **Docker** : Containerisation
- **GitHub Actions** : CI/CD
- **PostgreSQL** : Base de données
- **Redis** : Cache & sessions (à venir)

---

## 🏗 Architecture

### Structure de la base de données

```mermaid
erDiagram
    USER ||--o{ USER_SKILL : has
    USER ||--o{ TEAM : joins
    USER ||--o{ POST : creates
    USER ||--o{ MESSAGE : sends
    USER ||--o{ USER_BADGE : earns
    
    PROJECT ||--o{ TEAM : contains
    PROJECT ||--o{ PROJECT_SKILL : requires
    PROJECT ||--o{ MESSAGE : has
    
    SKILL ||--o{ USER_SKILL : defines
    SKILL ||--o{ PROJECT_SKILL : defines
    
    POST ||--o{ LIKE : receives
    
    BADGE ||--o{ USER_BADGE : award
Modèles principaux

User : Développeur avec compétences et badges
Project : Projet collaboratif avec statut
Team : Équipe projet avec rôles
Skill : Compétence technique
Message : Communication interne
Post : Publication sur le feed
Badge : Récompense utilisateur


🚀 Installation
Prérequis

Ruby 3.3.6
PostgreSQL 17
Node.js 20+ (pour Tailwind)
Git

Installation locale
# 1. Cloner le repo
git clone git@github.com:greegs0/ton-nom-de-projet.git
cd ton-nom-de-projet

# 2. Installer les dépendances
bundle install

# 3. Configurer la base de données
cp config/database.yml.example config/database.yml
# Éditer database.yml avec tes identifiants PostgreSQL

# 4. Créer et migrer la base de données
rails db:create
rails db:migrate

# 5. (Optionnel) Charger les données de test
rails db:seed

# 6. Lancer le serveur
bin/dev
L'application sera accessible sur http://localhost:3000

Installation avec Docker
# Build & run
docker-compose up --build

# Migrations
docker-compose exec web rails db:migrate

# Seeds
docker-compose exec web rails db:seed

💻 Utilisation
Créer un compte développeur
rails console
User.create!(
  email: "dev@example.com",
  password: "password123",
  username: "john_dev",
  bio: "Full-stack developer"
)
Ajouter des compétences
Skill.create!([
  { name: "Ruby on Rails", category: "backend" },
  { name: "React", category: "frontend" },
  { name: "PostgreSQL", category: "database" }
])
Créer un projet
project = Project.create!(
  title: "Mon Super Projet",
  description: "Description du projet",
  status: "recruiting",
  max_team_size: 5,
  owner: User.first
)

🗄 Base de données
Schéma complet
Le schéma de la base de données est disponible dans db/schema.rb.
Tables principales :

users : Utilisateurs (Devise)
projects : Projets collaboratifs
teams : Membres d'équipe
skills : Compétences techniques
user_skills : Liaison User ↔ Skill
project_skills : Liaison Project ↔ Skill
messages : Messagerie
posts : Publications
likes : Likes sur posts
badges : Badges gamification
user_badges : Badges gagnés

Migrations importantes
# Voir l'état des migrations
rails db:migrate:status

# Rollback dernière migration
rails db:rollback

# Reset complet
rails db:reset

🔌 API
Endpoints (Phase 2)
Documentation complète à venir. Endpoints prévus :
GET    /api/v1/projects          # Liste des projets
POST   /api/v1/projects          # Créer un projet
GET    /api/v1/projects/:id      # Détails d'un projet
PATCH  /api/v1/projects/:id      # Modifier un projet
DELETE /api/v1/projects/:id      # Supprimer un projet

GET    /api/v1/users             # Liste des devs
GET    /api/v1/users/:id         # Profil d'un dev
PATCH  /api/v1/users/:id         # Modifier son profil

🧪 Tests
Lancer les tests
# Tous les tests
rails test

# Tests spécifiques
rails test test/models/user_test.rb

# Avec couverture
COVERAGE=true rails test
Coverage attendue

Models : 90%+
Controllers : 80%+
Global : 85%+


🚢 Déploiement
Heroku
# Login
heroku login

# Créer l'app
heroku create nexp-production

# Ajouter PostgreSQL
heroku addons:create heroku-postgresql:essential-0

# Deploy
git push heroku main

# Migrations
heroku run rails db:migrate
heroku run rails db:seed
Render / Fly.io
Documentation à venir.

🤝 Contribuer
Les contributions sont les bienvenues ! Voici comment procéder :

Fork le projet
Créer une branche feature (git checkout -b feature/AmazingFeature)
Commit vos changements (git commit -m 'Add: Amazing feature')
Push vers la branche (git push origin feature/AmazingFeature)
Ouvrir une Pull Request

Guidelines

Suivre les conventions Ruby/Rails
Ajouter des tests pour les nouvelles features
Documenter les changements importants
Respecter le style de code existant


🗺 Roadmap
Q1 2025

 Setup projet Rails 8
 Modèles de données
 Interface utilisateur MVP
 Système de messagerie

Q2 2025

 Matching automatique
 Gamification complète
 API REST v1
 Dashboard analytics

Q3 2025

 Intégrations Git
 Mode sombre
 Mobile app (React Native ?)


📝 License
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

👨‍💻 Auteur
Greg - @greegs0

<div align="center">

Fait avec ❤️ et ☕ par la communauté dev
⬆ Retour en haut
</div>
```


🔥 Fichiers additionnels à créer :
1. CONTRIBUTING.md
# Guide de contribution

Merci de contribuer à NexP ! [...]
2. LICENSE
MIT License [...]
3. .github/ISSUE_TEMPLATE/bug_report.md
Template pour les bugs
4. .github/ISSUE_TEMPLATE/feature_request.md
Template pour les features
