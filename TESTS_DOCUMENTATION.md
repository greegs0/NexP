# Documentation des Tests - NexP

Ce document décrit l'ensemble des tests RSpec du projet NexP.

**Total : 129 tests**
- Tests modèles : 61
- Tests controllers (requests) : 68

---

## Tests des Modèles

### User Model (`spec/models/user_spec.rb`)

| Test | Description |
|------|-------------|
| `belongs_to :owned_projects` | Vérifie que l'utilisateur peut posséder plusieurs projets |
| `has_many :user_skills` | Vérifie l'association avec les compétences utilisateur |
| `has_many :skills through user_skills` | Vérifie l'accès aux skills via la table de jointure |
| `has_many :teams` | Vérifie l'association avec les équipes |
| `has_many :projects through teams` | Vérifie l'accès aux projets rejoints |
| `has_many :posts` | Vérifie l'association avec les posts |
| `has_many :likes` | Vérifie l'association avec les likes |
| `has_many :user_badges` | Vérifie l'association avec les badges utilisateur |
| `has_many :badges through user_badges` | Vérifie l'accès aux badges |
| `has_many :sent_messages` | Vérifie l'association avec les messages envoyés |
| `validates username presence` | Le username est obligatoire |
| `validates username uniqueness` | Le username doit être unique (case-insensitive) |
| `validates username format` | Le username doit contenir uniquement lettres, chiffres et underscore |
| `validates username length` | Le username doit faire entre 3 et 30 caractères |
| `validates email presence` | L'email est obligatoire |
| `validates email uniqueness` | L'email doit être unique |
| `validates bio length` | La bio ne doit pas dépasser 500 caractères |
| `validates zipcode format` | Le code postal doit contenir exactement 5 chiffres |
| `validates URL formats` | Les URLs (portfolio, github, linkedin) doivent être valides |
| `#display_name returns name if present` | Retourne le nom si défini |
| `#display_name returns username if no name` | Retourne le username si pas de nom |
| `#add_experience adds XP` | Ajoute de l'expérience et met à jour le niveau |
| `.available scope` | Filtre les utilisateurs disponibles |
| `normalize_username callback` | Normalise le username en minuscules |

---

### Project Model (`spec/models/project_spec.rb`)

| Test | Description |
|------|-------------|
| `belongs_to :owner` | Vérifie l'association avec le propriétaire |
| `has_many :teams` | Vérifie l'association avec les équipes |
| `has_many :members through teams` | Vérifie l'accès aux membres via teams |
| `has_many :project_skills` | Vérifie l'association avec project_skills |
| `has_many :skills through project_skills` | Vérifie l'accès aux skills requises |
| `has_many :messages` | Vérifie l'association avec les messages |
| `validates title presence` | Le titre est obligatoire |
| `validates title length` | Le titre doit faire entre 3 et 100 caractères |
| `validates description length` | La description ne doit pas dépasser 2000 caractères |
| `validates max_members range` | max_members doit être entre 1 et 50 |
| `validates status inclusion` | Le status doit être valide (draft, open, in_progress, completed, archived) |
| `validates visibility inclusion` | La visibilité doit être public ou private |
| `validates end_date > start_date` | La date de fin doit être après la date de début |
| `validates deadline >= today` | La deadline ne peut pas être dans le passé |
| `#full?` | Retourne true si le projet est complet |
| `#accepting_members?` | Retourne true si le projet accepte de nouveaux membres |
| `#member?(user)` | Vérifie si un utilisateur est membre |
| `.public_projects scope` | Filtre les projets publics |
| `.available scope` | Filtre les projets avec places disponibles |

---

### Skill Model (`spec/models/skill_spec.rb`)

| Test | Description |
|------|-------------|
| `has_many :user_skills` | Vérifie l'association avec user_skills |
| `has_many :users through user_skills` | Vérifie l'accès aux utilisateurs |
| `has_many :project_skills` | Vérifie l'association avec project_skills |
| `has_many :projects through project_skills` | Vérifie l'accès aux projets |
| `validates name presence` | Le nom est obligatoire |
| `validates name uniqueness` | Le nom doit être unique |
| `validates category presence` | La catégorie est obligatoire |
| `validates category inclusion` | La catégorie doit être valide |
| `.by_category scope` | Filtre par catégorie |
| `.search scope` | Recherche par nom (case-insensitive) |

---

## Tests des Controllers (Requests)

### Dashboard (`spec/requests/dashboard_spec.rb`)

| Test | Description |
|------|-------------|
| `GET /dashboard redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `GET /dashboard returns success when authenticated` | Retourne 200 OK pour un utilisateur connecté |
| `GET /dashboard displays user information` | Affiche le nom de l'utilisateur |
| `GET /dashboard shows user skills` | Affiche les compétences de l'utilisateur |
| `GET /dashboard shows recent projects` | Affiche les projets créés par l'utilisateur |
| `GET /dashboard shows joined projects` | Affiche les projets rejoints par l'utilisateur |

---

### Projects (`spec/requests/projects_spec.rb`)

#### GET /projects (Index)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `returns http success` | Retourne 200 OK |
| `shows only public projects` | N'affiche que les projets publics |
| `filters by status` | Filtre correctement par statut |
| `filters by search term` | Filtre correctement par terme de recherche |

#### GET /projects/:id (Show)

| Test | Description |
|------|-------------|
| `returns http success for existing project` | Retourne 200 OK pour un projet existant |
| `redirects for non-existing project` | Redirige si le projet n'existe pas |

#### GET /projects/new (New)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `returns http success when authenticated` | Retourne 200 OK pour un utilisateur connecté |

#### POST /projects (Create)

| Test | Description |
|------|-------------|
| `creates a new project with valid params` | Crée un projet avec des paramètres valides |
| `does not create with invalid params` | Ne crée pas de projet avec des paramètres invalides |
| `sets current user as owner` | Définit l'utilisateur courant comme propriétaire |

#### GET /projects/:id/edit (Edit)

| Test | Description |
|------|-------------|
| `returns http success for owner` | Retourne 200 OK pour le propriétaire |
| `redirects non-owner` | Redirige si l'utilisateur n'est pas propriétaire |

#### PATCH /projects/:id (Update)

| Test | Description |
|------|-------------|
| `updates project for owner` | Met à jour le projet pour le propriétaire |
| `does not update for non-owner` | Ne met pas à jour pour un non-propriétaire |

#### DELETE /projects/:id (Destroy)

| Test | Description |
|------|-------------|
| `destroys project for owner` | Supprime le projet pour le propriétaire |
| `does not destroy for non-owner` | Ne supprime pas pour un non-propriétaire |

#### POST /projects/:id/join (Join)

| Test | Description |
|------|-------------|
| `allows user to join a project` | Permet à un utilisateur de rejoindre un projet |
| `does not allow joining twice` | Empêche de rejoindre deux fois le même projet |
| `does not allow joining a full project` | Empêche de rejoindre un projet complet |

#### DELETE /projects/:id/leave (Leave)

| Test | Description |
|------|-------------|
| `allows user to leave a project` | Permet à un utilisateur de quitter un projet |
| `does not allow owner to leave` | Empêche le propriétaire de quitter son projet |
| `does not allow leaving if not a member` | Empêche de quitter si pas membre |

---

### Messages (`spec/requests/messages_spec.rb`)

#### GET /projects/:project_id/messages (Index)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `returns success for project owner` | Retourne 200 OK pour le propriétaire du projet |
| `displays project messages` | Affiche les messages du projet |
| `returns success for project member` | Retourne 200 OK pour un membre du projet |
| `redirects when not a member` | Redirige si l'utilisateur n'est pas membre |

#### POST /projects/:project_id/messages (Create)

| Test | Description |
|------|-------------|
| `creates a new message` | Crée un nouveau message |
| `sets sender to current user` | Définit l'expéditeur comme l'utilisateur courant |
| `sanitizes HTML content` | Nettoie le contenu HTML (protection XSS) |
| `does not create with blank content` | Ne crée pas de message avec contenu vide |
| `does not create message exceeding max length` | Ne crée pas de message dépassant 1000 caractères |
| `creates message for project member` | Permet aux membres de créer des messages |
| `does not create message for non-member` | Empêche les non-membres de créer des messages |

---

### Skills (`spec/requests/skills_spec.rb`)

#### GET /skills (Index)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `returns http success` | Retourne 200 OK |
| `displays available skills` | Affiche les compétences disponibles |
| `filters by category` | Filtre par catégorie |
| `filters by search term` | Filtre par terme de recherche |

#### GET /skills/:id (Show)

| Test | Description |
|------|-------------|
| `returns http success` | Retourne 200 OK |
| `displays skill details` | Affiche les détails de la compétence |
| `shows users with this skill` | Affiche les utilisateurs ayant cette compétence |

---

### User Skills (`spec/requests/user_skills_spec.rb`)

#### POST /user_skills (Create)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `adds a skill to the user` | Ajoute une compétence à l'utilisateur |
| `does not add the same skill twice` | Empêche l'ajout de la même compétence deux fois |
| `redirects to skills page` | Redirige vers la page des compétences |

#### DELETE /user_skills/:id (Destroy)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `removes a skill from the user` | Retire une compétence de l'utilisateur |
| `does not allow removing another user's skill` | Empêche de retirer la compétence d'un autre utilisateur |
| `redirects to skills page` | Redirige vers la page des compétences |

---

### Users (`spec/requests/users_spec.rb`)

#### GET /users/:id (Show)

| Test | Description |
|------|-------------|
| `redirects when not authenticated` | Redirige vers la connexion si non authentifié |
| `returns http success` | Retourne 200 OK |
| `displays user information` | Affiche les informations de l'utilisateur |
| `displays user skills` | Affiche les compétences de l'utilisateur |

#### GET /users/:id/portfolio (Portfolio)

| Test | Description |
|------|-------------|
| `returns http success` | Retourne 200 OK |
| `displays portfolio page` | Affiche la page portfolio |
| `shows user projects` | Affiche les projets de l'utilisateur |

#### PATCH /users/:id/toggle_availability (Toggle Availability)

| Test | Description |
|------|-------------|
| `toggles availability for own profile` | Change la disponibilité de son propre profil |
| `returns updated availability in JSON` | Retourne la disponibilité mise à jour en JSON |
| `does not allow toggling another user's availability` | Empêche de changer la disponibilité d'un autre utilisateur |

---

## Exécution des Tests

```bash
# Tous les tests
bundle exec rspec

# Tests avec documentation
bundle exec rspec --format documentation

# Tests d'un fichier spécifique
bundle exec rspec spec/models/user_spec.rb

# Tests d'un seul test
bundle exec rspec spec/requests/projects_spec.rb:47

# Tests avec couverture
bundle exec rspec --format progress
```

---

## Factories Disponibles

| Factory | Traits | Description |
|---------|--------|-------------|
| `user` | `with_skills`, `unavailable`, `high_level` | Utilisateur |
| `project` | `in_progress`, `completed`, `private`, `full`, `with_skills` | Projet |
| `skill` | - | Compétence |
| `team` | - | Équipe (association user-project) |
| `user_skill` | - | Association user-skill |
| `project_skill` | - | Association project-skill |
| `message` | `read`, `long_content` | Message |

---

## Couverture de Sécurité

Les tests vérifient les aspects de sécurité suivants :

| Aspect | Tests |
|--------|-------|
| **Authentification** | Tous les endpoints redirigent vers login si non authentifié |
| **Autorisation owner** | Seul le propriétaire peut modifier/supprimer son projet |
| **Autorisation member** | Seuls les membres peuvent accéder aux messages |
| **Scoped queries** | Impossible d'accéder aux ressources d'autres utilisateurs |
| **Sanitization XSS** | Le contenu HTML est nettoyé avant sauvegarde |
| **Validation données** | Les données invalides sont rejetées |
| **Race conditions** | Les actions join/leave utilisent des transactions |

---

*Documentation générée le 15 janvier 2026*
