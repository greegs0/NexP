# NexP - Direction Artistique (DA) - Documentation d'Implémentation

## ✅ Tâches Complétées

### 1. Système de Thème Dark/Light

#### Fichiers créés:
- `config/tailwind.config.js` - Configuration Tailwind avec couleurs personnalisées
- `app/assets/stylesheets/theme.css` - Variables CSS et styles pour les deux thèmes
- `app/javascript/controllers/theme_controller.js` - Contrôleur Stimulus pour le toggle

#### Couleurs implémentées:

**Mode Clair (Light):**
```css
--bg-app: #FAFAFA
--bg-primary: #FFFFFF
--bg-secondary: #F5F5F5
--bg-tertiary: #E8E8E8
--accent-primary: #62754C (brun kaki)
--accent-light: #8FA375
--accent-muted: #475335
```

**Mode Sombre (Dark):**
```css
--bg-app: #0A0A0A
--bg-primary: #1A1A1A
--bg-secondary: #2A2A2A
--bg-tertiary: #3A3A3A
--accent-primary: #62754C (brun kaki)
--accent-light: #8FA375
--accent-muted: #475335
```

Le thème est sauvegardé dans `localStorage` et détecte automatiquement les préférences système.

---

### 2. Sidebar Moderne et Collapsible

#### Fichiers créés:
- `app/views/shared/_sidebar.html.erb` - Sidebar avec navigation
- `app/javascript/controllers/sidebar_controller.js` - Logique de collapse

#### Fonctionnalités:
- ✅ Navigation vers Dashboard, Compétences, Projets, Profil
- ✅ Collapsible sur desktop (icons seulement quand fermée)
- ✅ Cachée par défaut sur mobile avec overlay
- ✅ État sauvegardé dans localStorage
- ✅ Logo NexP
- ✅ Section utilisateur avec avatar, niveau et déconnexion

---

### 3. Layout Principal

#### Fichier modifié:
- `app/views/layouts/application.html.erb`

#### Améliorations:
- ✅ Détection `user_signed_in?` pour afficher sidebar + navbar
- ✅ Layout centré pour pages non-authentifiées (login/signup/erreurs)
- ✅ Flash messages stylés (notice = vert, alert = rouge)
- ✅ Margins réactives selon état sidebar
- ✅ Responsive mobile-first

---

### 4. Pages Devise Stylées

#### Fichiers modifiés:
- `app/views/devise/sessions/new.html.erb` - Page de connexion
- `app/views/devise/registrations/new.html.erb` - Page d'inscription

#### Caractéristiques:
- ✅ Design minimaliste et moderne
- ✅ Formulaires avec inputs stylés
- ✅ Citations humoristiques de dev en bas de page
- ✅ Liens vers "Mot de passe oublié" et "Créer un compte"
- ✅ Support des champs personnalisés (username, name)

---

### 5. Pages d'Erreur avec Humour de Dev

#### Fichiers modifiés:
- `public/404.html` - Page introuvable
- `public/500.html` - Erreur serveur
- `public/422.html` - Requête invalide

#### Contenu:
- ✅ **404**: "Houston, on a un problème... La page est partie faire un git push vers l'infini 🚀"
- ✅ **500**: "Erreur critique détectée! Probablement un undefined is not a function 💥"
- ✅ **422**: "Demande invalide détectée! Token CSRF manquant ou validations qui ont dit Nope! ❌"
- ✅ Blocs de code humoristiques
- ✅ Citations de devs célèbres
- ✅ Boutons de retour stylés

---

### 6. Pagination (Kaminari)

#### Modifications:
- `Gemfile` - Ajout de `gem "kaminari"`
- `app/controllers/projects_controller.rb` - Ajout de `.page(params[:page]).per(12)`

#### Fonctionnalité:
- ✅ Pagination automatique des projets (12 par page)
- ✅ Bug de pagination corrigé (méthode `.page()` maintenant disponible)

---

### 7. Recherche en Temps Réel (Stimulus)

#### Fichier créé:
- `app/javascript/controllers/search_controller.js`

#### Fonctionnalités:
- ✅ Debounce de 300ms pour éviter trop de requêtes
- ✅ Compatible avec Turbo Streams
- ✅ Préservation des autres paramètres (category, filters)
- ✅ Prêt pour Skills et Projects

#### Comment l'utiliser dans les vues:

```erb
<div data-controller="search" data-search-url-value="<%= skills_path %>">
  <%= form_with url: skills_path, method: :get do |f| %>
    <%= f.text_field :search,
        data: {
          search_target: "input",
          action: "input->search#search"
        },
        placeholder: "Rechercher..." %>
  <% end %>

  <div id="results" data-search-target="results">
    <!-- Résultats ici -->
  </div>
</div>
```

---

## 📝 À Faire Manuellement

### 1. Adapter les vues existantes à la DA

Vous devez remplacer les classes Tailwind existantes dans les vues par les classes de la DA:

#### Classes à utiliser:

**Backgrounds:**
```erb
class="bg-app"       <!-- Fond principal de l'app -->
class="bg-primary"   <!-- Fond des cards/sections -->
class="bg-secondary" <!-- Fond des éléments secondaires -->
class="bg-tertiary"  <!-- Fond hover states -->
```

**Boutons:**
```erb
class="btn-accent"     <!-- Bouton principal (vert kaki) -->
class="btn-secondary"  <!-- Bouton secondaire (gris) -->
```

**Textes:**
```erb
class="text-primary"   <!-- Titres principaux -->
class="text-secondary" <!-- Paragraphes -->
class="text-muted"     <!-- Labels, infos secondaires -->
```

**Cards:**
```erb
class="card"  <!-- Card avec bordure subtile et hover -->
```

**Inputs:**
```erb
class="input"  <!-- Input stylé avec focus vert kaki -->
```

#### Exemple de transformation:

**Avant:**
```erb
<div class="bg-white rounded-lg shadow p-6">
  <h2 class="text-xl font-bold text-gray-900">Titre</h2>
  <p class="text-gray-600">Description</p>
  <button class="bg-blue-600 text-white px-4 py-2 rounded">Action</button>
</div>
```

**Après:**
```erb
<div class="card">
  <h2 class="text-xl font-bold text-primary">Titre</h2>
  <p class="text-secondary">Description</p>
  <button class="btn-accent">Action</button>
</div>
```

---

### 2. Implémenter la recherche en temps réel

#### Pour la page Skills (`app/views/skills/index.html.erb`):

Modifiez le partial `_search_bar.html.erb`:

```erb
<div class="search-bar" data-controller="search" data-search-url-value="<%= skills_path %>">
  <%= form_with url: skills_path, method: :get, local: false do |f| %>
    <%= f.text_field :search,
        placeholder: "Rechercher une compétence...",
        value: params[:search],
        class: "input",
        data: {
          search_target: "input",
          action: "input->search#search"
        } %>
  <% end %>
</div>
```

#### Pour la page Projects (`app/views/projects/index.html.erb`):

Ajoutez un champ de recherche similaire en haut de la liste des projets.

---

### 3. Ajouter Turbo Streams pour les recherches

Dans les contrôleurs (`skills_controller.rb`, `projects_controller.rb`), ajoutez:

```ruby
def index
  # ... votre logique existante ...

  respond_to do |format|
    format.html
    format.turbo_stream do
      render turbo_stream: turbo_stream.update("results", partial: "skills/results", locals: { skills: @available_skills })
    end
  end
end
```

Créez un partial `_results.html.erb` pour chaque vue avec juste la liste des résultats.

---

### 4. Navbar avec titre dynamique

Dans chaque vue, ajoutez en haut:

```erb
<% content_for :page_title do %>
  Titre de la Page
<% end %>
```

Exemple:
```erb
<!-- app/views/skills/index.html.erb -->
<% content_for :page_title, "Compétences" %>
```

---

### 5. Vues Projects complètes

Les vues suivantes doivent être créées/adaptées:

- `app/views/projects/index.html.erb` - Liste des projets avec filtres
- `app/views/projects/show.html.erb` - Détails d'un projet
- `app/views/projects/new.html.erb` - Création de projet
- `app/views/projects/edit.html.erb` - Édition de projet
- `app/views/projects/_form.html.erb` - Formulaire partagé

**Structure recommandée pour `index.html.erb`:**

```erb
<% content_for :page_title, "Projets" %>

<div class="mb-6">
  <div class="flex justify-between items-center mb-4">
    <h1 class="text-3xl font-bold text-primary">Projets</h1>
    <%= link_to "Créer un projet", new_project_path, class: "btn-accent" %>
  </div>

  <!-- Barre de recherche -->
  <div class="card mb-4">
    <!-- Ajoutez ici le système de recherche en temps réel -->
  </div>
</div>

<!-- Liste des projets -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <% @projects.each do |project| %>
    <div class="card hover:shadow-lg transition">
      <!-- Contenu de la card projet -->
    </div>
  <% end %>
</div>

<!-- Pagination Kaminari -->
<div class="mt-8">
  <%= paginate @projects, theme: 'custom' %>
</div>
```

---

## 🎨 Personnaliser le Thème Kaminari

Générez les vues Kaminari:

```bash
rails generate kaminari:views
```

Ensuite, modifiez les fichiers dans `app/views/kaminari/` pour utiliser les classes de la DA:

```erb
<!-- app/views/kaminari/_page.html.erb -->
<li class="<%= 'active' if page.current? %>">
  <%= link_to page, url, class: "px-3 py-2 rounded hover:bg-accent text-primary" %>
</li>
```

---

## 🚀 Lancer le Serveur

```bash
bundle install
rails assets:precompile
rails server
```

Visitez: `http://localhost:3000`

---

## 🔑 Commandes Utiles

```bash
# Compiler les assets
rails assets:precompile

# Nettoyer les assets
rails assets:clobber

# Lancer les tests
bundle exec rspec

# Console Rails
rails console
```

---

## 📦 Stack Technique

- **Ruby**: 3.3.5
- **Rails**: 7.1.6
- **Database**: PostgreSQL 17
- **CSS**: Tailwind CSS v4 + Custom CSS Variables
- **JS**: Stimulus + Turbo
- **Auth**: Devise
- **Pagination**: Kaminari
- **Tests**: RSpec

---

## 🎯 Prochaines Étapes Recommandées

1. ✅ Adapter toutes les vues à la DA (Dashboard, Skills, Projects, Users)
2. ✅ Implémenter Turbo Streams pour recherches en temps réel
3. ✅ Créer les vues Projects complètes (new, edit, show)
4. ✅ Ajouter des animations CSS pour les transitions
5. ✅ Tester sur mobile et ajuster le responsive
6. ✅ Ajouter des illustrations/images si nécessaire
7. ✅ Optimiser les performances (lazy loading, image compression)

---

## 🐛 Debug

Si vous rencontrez des problèmes:

1. Vérifiez que theme.css est bien chargé: `<%= stylesheet_link_tag "theme" %>`
2. Vérifiez la console navigateur pour les erreurs JS
3. Vérifiez les logs Rails pour les erreurs serveur
4. Testez le toggle dark/light dans la navbar

---

**Bon développement! 🚀**

*"Il n'y a pas de bug, juste des features non documentées."* 🐛
