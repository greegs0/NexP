<div align="center">

# NexP

### Plateforme collaborative nouvelle génération pour développeurs

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.1-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Early%20Development-orange.svg)]()

[Contribuer](#contribuer)

</div>

---

## Table des matières

- [À propos](#à-propos)
- [Fonctionnalités](#fonctionnalités)
- [Stack technique](#stack-technique)
- [Architecture](#architecture)
- [Installation](#installation)
- [Roadmap](#roadmap)
- [Contribuer](#contribuer)
- [License](#license)

---

## À propos

**NexP** est une plateforme collaborative conçue pour connecter les développeurs autour de projets communs. Elle permet de :

- **Découvrir** des projets en fonction de ses compétences
- **Collaborer** avec d'autres devs en temps réel
- **Suivre** l'avancement des projets via un dashboard intuitif
- **Gagner** des badges en fonction de vos contributions
- **Échanger** via un système de messagerie intégré

---

## Fonctionnalités

### En cours de développement

- [x] Setup projet Rails 8
- [x] Architecture base de données
- [ ] Authentification utilisateur (Devise)
- [ ] Gestion des profils développeurs
- [ ] Système de compétences (skills)
- [ ] Création et gestion de projets
- [ ] Équipes et collaborations
- [ ] Messagerie interne
- [ ] Feed social (posts + likes)

### Fonctionnalités futures

- [ ] Matching automatique projet/développeur
- [ ] Système de badges et gamification
- [ ] Notifications temps réel (ActionCable)
- [ ] API REST
- [ ] Dashboard analytics
- [ ] Intégrations GitHub/GitLab
- [ ] Mode sombre

---

## Stack technique

### Backend

| Technologie | Version | Usage |
|-------------|---------|-------|
| Ruby | 3.3.6 | Langage principal |
| Rails | 8.0.1 | Framework web |
| PostgreSQL | 17 | Base de données |
| Puma | 6.5 | Serveur web |

### Frontend

| Technologie | Version | Usage |
|-------------|---------|-------|
| Hotwire | - | Interactivité |
| Stimulus | 3.2 | JavaScript framework |
| Tailwind CSS | 3.4 | Styling |
| ImportMap | - | Gestion JS |

---

## Architecture

### Structure de la base de données

![Database Schema](app/assets/images/NexP.png)

**Modèles principaux :**

- **User** : Développeur avec compétences et portfolio
- **Project** : Projet collaboratif avec équipe
- **Team** : Association user ↔ project avec rôles
- **Skill** : Compétences techniques (tags)
- **Message** : Messagerie interne projet
- **Post** : Feed social + likes
- **Badge** : Système de gamification

---

## Installation

### Prérequis

- Ruby 3.3.6
- Rails 8.0.1
- PostgreSQL 17
- Node.js 20+ (pour Tailwind/Stimulus)

### Setup

```bash
# Clone le repo
git clone https://github.com/greegs0/NexP.git
cd NexP

# Install dependencies
bundle install
yarn install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Lancer le serveur
bin/dev
