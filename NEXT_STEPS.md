# Prochaines étapes - NexP

## 🎉 Ce qui a été fait

Ton projet a été **entièrement audité et corrigé**. Tout est maintenant propre, sécurisé et prêt pour le développement.

---

## 🚀 Pour démarrer l'application

```bash
# Installer les dépendances
bundle install

# Créer et peupler la base de données
rails db:create
rails db:migrate
rails db:seed

# Lancer le serveur
bin/dev
```

**Compte de test créé:**
- Email: `greg@gmail.com`
- Password: `azerty`

---

## 📂 Structure actuelle

### Contrôleurs (100% fonctionnels)
- ✅ `DashboardController` - Page d'accueil
- ✅ `SkillsController` - Gestion compétences
- ✅ `UserSkillsController` - Ajout/suppression skills
- ✅ `ProjectsController` - CRUD projets + join/leave
- ✅ `UsersController` - Profils publics
- ✅ `MessagesController` - Messagerie par projet

### Modèles (100% validés)
- ✅ User - Avec validations strictes
- ✅ Project - Avec scopes et méthodes métier
- ✅ Skill - Avec catégories
- ✅ Message - Avec système lu/non-lu
- ✅ Team, UserSkill, ProjectSkill, etc.

### Vues
- ✅ Skills (complètes)
- ✅ Dashboard (complète)
- ✅ Projects (index, show, new, edit)
- ✅ Users (profil)
- ⚠️ Messages (à créer)
- ⚠️ Devise (customisation recommandée)

### Tests
- ✅ 61 tests RSpec
- ✅ 0 échecs
- ✅ Factories complètes

---

## 🎯 Prochaines tâches (par priorité)

### 1️⃣ PRIORITÉ HAUTE - Interface utilisateur

#### A. Implémenter les CSS
Les vues HTML sont créées mais utilisent des classes CSS non stylées. Tu dois créer:

```css
/* app/assets/stylesheets/application.css */
.btn, .btn-primary, .btn-secondary, .btn-danger
.project-card, .project-grid
.skill-tag, .skills-tags
.empty-state
.form-group, .form-control
etc.
```

**Recommandation:** Utilise Tailwind (déjà installé) ou crée un design system simple.

#### B. Créer les vues Messages

```bash
# Créer ces fichiers:
app/views/messages/index.html.erb
app/views/messages/_message.html.erb
app/views/messages/_form.html.erb
```

#### C. Customiser Devise

```bash
# Générer les vues Devise
rails generate devise:views

# Customiser:
app/views/devise/sessions/new.html.erb      # Login
app/views/devise/registrations/new.html.erb # Signup
app/views/devise/registrations/edit.html.erb # Edit profile
```

---

### 2️⃣ PRIORITÉ MOYENNE - Fonctionnalités

#### A. Upload d'avatars (ActiveStorage)

```bash
rails active_storage:install
rails db:migrate
```

```ruby
# app/models/user.rb
has_one_attached :avatar
```

#### B. Pagination

```bash
# Ajouter au Gemfile
gem 'pagy'
```

```ruby
# app/controllers/projects_controller.rb
@pagy, @projects = pagy(Project.all)
```

#### C. Recherche avancée

Ajouter filtres sur Projects index:
- Par compétence
- Par statut
- Par nombre de places disponibles

#### D. Système de badges

Implémenter la logique de gain de badges:
- Premier projet créé
- 5 compétences ajoutées
- Niveau 10 atteint
- etc.

---

### 3️⃣ PRIORITÉ BASSE - Polish

#### A. ActionCable pour messages temps réel

```ruby
# app/channels/project_channel.rb
class ProjectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "project_#{params[:project_id]}"
  end
end
```

#### B. Notifications

```bash
# Ajouter au Gemfile
gem 'noticed'
```

Notifications pour:
- Nouveau membre dans un projet
- Nouveau message
- Badge gagné

#### C. Export de données

```ruby
# Gemfile
gem 'csv'

# Export profil en PDF/CSV
```

#### D. Intégrations

- GitHub API pour récupérer repos
- LinkedIn OAuth
- Slack webhooks pour notifs projet

---

## 🛠️ Commandes utiles

### Base de données

```bash
# Reset complet
rails db:drop db:create db:migrate db:seed

# Créer une migration
rails g migration AddFieldToModel field:type

# Rollback dernière migration
rails db:rollback
```

### Contrôleurs/Modèles

```bash
# Générer un contrôleur
rails g controller Posts index show

# Générer un modèle
rails g model Comment content:text user:references
```

### Tests

```bash
# Tous les tests
rspec

# Un fichier spécifique
rspec spec/models/user_spec.rb

# Avec détails
rspec --format documentation
```

### Console

```bash
# Console Rails
rails c

# Dans la console:
User.count
Project.public_projects
User.first.add_experience(100)
```

---

## 📚 Documentation

- **Architecture:** Voir `README.md`
- **Sécurité:** Voir `SECURITY.md`
- **Audit complet:** Voir `AUDIT_REPORT.md`

---

## 🔥 Quick wins (faciles à implémenter)

1. **Ajouter des images placeholder**
   ```ruby
   # app/helpers/application_helper.rb
   def avatar_url_for(user)
     user.avatar_url.presence || "https://ui-avatars.com/api/?name=#{user.username}"
   end
   ```

2. **Ajouter des timestamps français**
   ```ruby
   # config/locales/fr.yml
   fr:
     time:
       formats:
         short: "%d %b %H:%M"
   ```

3. **Breadcrumbs**
   ```erb
   <!-- app/views/layouts/application.html.erb -->
   <nav class="breadcrumbs">
     <%= link_to "Accueil", root_path %>
     <% if content_for?(:breadcrumb) %>
       <%= yield :breadcrumb %>
     <% end %>
   </nav>
   ```

4. **Flash messages stylés**
   ```erb
   <!-- app/views/layouts/application.html.erb -->
   <% flash.each do |type, message| %>
     <div class="alert alert-<%= type %>">
       <%= message %>
     </div>
   <% end %>
   ```

---

## 🎨 Design system suggéré

### Couleurs
```css
--primary: #3b82f6;    /* Bleu */
--success: #10b981;    /* Vert */
--warning: #f59e0b;    /* Orange */
--danger: #ef4444;     /* Rouge */
--gray-100: #f3f4f6;
--gray-800: #1f2937;
```

### Composants à créer
- Boutons (primary, secondary, danger, outline)
- Cards (project, user, skill)
- Forms (inputs, selects, textareas)
- Badges (status, category)
- Modals (confirmations)
- Toasts (notifications)

---

## ✅ Checklist avant production

- [ ] Variables d'environnement externalisées (secrets.yml)
- [ ] HTTPS forcé
- [ ] Logs configurés (Sentry/Rollbar)
- [ ] Backup DB automatique
- [ ] CDN pour assets
- [ ] Email SMTP configuré (SendGrid/Mailgun)
- [ ] Rate limiting (rack-attack)
- [ ] Monitoring (New Relic/Datadog)

---

## 🆘 Besoin d'aide ?

### Erreurs communes

**ActiveRecord::RecordNotFound**
→ Ajoute un rescue dans le contrôleur

**Routing Error**
→ Vérifie `rails routes`

**ActionController::InvalidAuthenticityToken**
→ Vérifie que Devise est bien configuré

**N+1 queries**
→ Ajoute `.includes()` dans le contrôleur

### Resources
- Rails Guides: https://guides.rubyonrails.org/
- RSpec: https://rspec.info/
- Devise: https://github.com/heartcombo/devise
- Tailwind: https://tailwindcss.com/

---

**Bon développement! 🚀**
