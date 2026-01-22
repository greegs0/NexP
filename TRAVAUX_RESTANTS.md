# Travaux Restants - NexP UI Improvements

## ✅ Terminé

### Pages d'authentification (Login/Signup)
- ✅ Logo navbar agrandi (h-14)
- ✅ Espacement navbar amélioré (gap-8)
- ✅ Toggle thème iOS-style ajouté
- ✅ Hero section redessinée (logo + titre sur même ligne)
- ✅ Messages d'erreur fixés (texte clair sur fond rouge)
- ✅ Touches de kaki dans le texte hero

### Dashboard
- ✅ Navbar dupliquée supprimée partout
- ✅ Tous les emojis enlevés
- ✅ Icons SVG ajoutées pour les cards stats
- ✅ Toggle thème iOS dans sidebar
- ✅ Notifications en haut de sidebar
- ✅ Sidebar toggle repositionné (décalé quand fermée)
- ✅ Hover sidebar liens en kaki

### Compétences
- ✅ Recherche dynamique (déjà fonctionnelle)
- ✅ Catégorie sélectionnée texte blanc
- ✅ Ajout/suppression fluide sans rechargement (Turbo Streams)
- ✅ Emoji enlevé du titre

### Projets
- ✅ Recherche dynamique (déjà fonctionnelle)
- ✅ Sections recherche et statut équilibrées (grid 2 cols)
- ✅ Statuts traduits en français (helper créé)
- ✅ Emoji enlevé du titre

## ⚠️ À Finaliser Manuellement

### 1. Profil utilisateur (`app/views/users/show.html.erb`)

**Emojis à remplacer:**
- Ligne 30 : `📍` → Icon SVG location (déjà fourni dans le code ci-dessous)
- Ligne 35 : `⭐` → Icon SVG star (déjà fourni)
- Ligne 40 : `✅` → Remplacer par toggle iOS pour @is_current_user
- Ligne 67 : `⚡` → Enlever
- Ligne 95 : `🚀` → Enlever
- Ligne 173 : `🏆` → Enlever

**Code à copier pour remplacer les lignes 27-55:**

```erb
        <div class="flex flex-wrap gap-4 mb-4 text-sm">
          <% if @user.zipcode.present? %>
            <span class="flex items-center gap-1 text-secondary">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
              </svg>
              <%= @user.zipcode %>
            </span>
          <% end %>

          <span class="flex items-center gap-1 text-secondary">
            <svg class="w-4 h-4 text-accent" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
            </svg>
            Niveau <%= @user.level %> (<%= @user.experience_points %> XP)
          </span>

          <% if @is_current_user %>
            <span class="flex items-center gap-2" id="availability_toggle">
              <label class="availability-toggle-switch" aria-label="Toggle availability">
                <input type="checkbox" <%= @user.available ? 'checked' : '' %> data-controller="availability-toggle" data-availability-toggle-user-id-value="<%= @user.id %>" data-action="change->availability-toggle#toggle" class="availability-toggle-checkbox">
                <span class="availability-toggle-slider"></span>
              </label>
              <span class="text-sm text-secondary" data-availability-toggle-target="label"><%= @user.available ? 'Disponible' : 'Non disponible' %></span>
            </span>
          <% elsif @user.available %>
            <span class="px-3 py-1 bg-success text-white rounded-full text-xs font-medium">
              Disponible
            </span>
          <% end %>
        </div>

        <div class="flex flex-wrap gap-2 mb-4">
          <% if @user.portfolio_url.present? %>
            <%= link_to @user.portfolio_url, target: "_blank", rel: "noopener", class: "inline-flex items-center gap-2 btn-secondary text-sm" do %>
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"></path>
              </svg>
              Portfolio
            <% end %>
          <% end %>
          <% if @user.github_url.present? %>
            <%= link_to @user.github_url, target: "_blank", rel: "noopener", class: "inline-flex items-center gap-2 btn-secondary text-sm" do %>
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                <path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd"></path>
              </svg>
              GitHub
            <% end %>
          <% end %>
          <% if @user.linkedin_url.present% %>
            <%= link_to @user.linkedin_url, target: "_blank", rel: "noopener", class: "inline-flex items-center gap-2 btn-secondary text-sm" do %>
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"></path>
              </svg>
              LinkedIn
            <% end %>
          <% end %>
        </div>
```

**Ajouter "Voir le projet →" dans les cards projets:**
- Lignes 101-122 (projets créés) : Ajouter avant le `</div>` final de chaque card:
```erb
              <%= link_to "Voir le projet →", project_path(project), class: "text-accent hover:text-accent-light text-sm font-medium mt-3 inline-block" %>
```

- Lignes 131-152 (projets rejoints) : Même chose

**Utiliser helper translate_status pour les statuts:**
- Ligne 108 : Remplacer `<%= project.status.titleize %>` par `<%= translate_status(project.status) %>`
- Ligne 138 : Idem

### 2. Créer le contrôleur Stimulus pour le toggle availability

**Fichier:** `app/javascript/controllers/availability_toggle_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]
  static values = {
    userId: Number
  }

  toggle(event) {
    const isAvailable = event.target.checked

    fetch(`/users/${this.userIdValue}/toggle_availability`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ available: isAvailable })
    })
    .then(response => response.json())
    .then(data => {
      if (this.hasLabelTarget) {
        this.labelTarget.textContent = isAvailable ? 'Disponible' : 'Non disponible'
      }
    })
    .catch(error => {
      console.error('Error:', error)
      // Revert checkbox on error
      event.target.checked = !isAvailable
    })
  }
}
```

### 3. Ajouter route et action pour toggle_availability

**Dans `config/routes.rb`:**
```ruby
resources :users, only: [:show] do
  member do
    patch :toggle_availability
  end
end
```

**Dans `app/controllers/users_controller.rb`:**
```ruby
def toggle_availability
  if current_user == @user
    @user.update(available: params[:available])
    render json: { available: @user.available }
  else
    render json: { error: 'Unauthorized' }, status: :forbidden
  end
end
```

### 4. Page Edit Profile (`app/views/devise/registrations/edit.html.erb`)

Cette page doit utiliser le layout "application" avec sidebar, pas le layout "devise".

**Solution:** Ajouter dans `app/controllers/application_controller.rb` la méthode:

```ruby
def layout_by_resource
  if devise_controller? && !(controller_name == 'registrations' && action_name == 'edit')
    "devise"
  else
    "application"
  end
end
```

Puis styler la page edit en mode DA (card, inputs stylés, boutons accent, etc.)

### 5. Pages d'erreur (404, 422, 500)

**Problème:** Encoding cassé (caractères bizarres)

**Fichiers à vérifier:**
- `public/404.html`
- `public/422.html`
- `public/500.html`

Assurez-vous que ces fichiers:
1. Ont `<meta charset="UTF-8">` dans le head
2. Sont encodés en UTF-8
3. Utilisent les classes de theme.css (bg-primary, text-primary, etc.)
4. Ont le même style que le reste du site

## 🎨 Nouvelles Features Ajoutées

- **Toggle iOS pour thème**: Dans sidebar et auth pages
- **Toggle iOS pour disponibilité**: À finaliser dans profil
- **Icons SVG**: Portfolio, GitHub, LinkedIn avec icônes intégrées
- **Turbo Streams**: Ajout/suppression compétences sans rechargement
- **Helper translate_status**: Traduction des statuts de projet
- **Recherche dynamique**: Déjà fonctionnelle partout

## 📝 Notes Importantes

1. Tous les assets ont été recompilés
2. Le contrôleur theme a été mis à jour pour supporter les checkboxes
3. La sidebar affiche maintenant notifications + toggle thème en haut
4. Les hovers sont fixés partout (texte blanc sur boutons accent)
5. La navbar dupliquée a été supprimée de tout le site
