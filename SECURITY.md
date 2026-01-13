# Sécurité - NexP

## Mesures de sécurité implémentées

### 1. Authentification et Autorisation

- ✅ **Devise** pour l'authentification sécurisée
- ✅ `before_action :authenticate_user!` sur tous les contrôleurs sensibles
- ✅ Vérification des permissions (owner, member) avant actions sensibles
- ✅ Strong parameters sur tous les contrôleurs
- ✅ Validation des IDs utilisateur pour éviter l'accès non autorisé

### 2. Protection CSRF

- ✅ `protect_from_forgery with: :exception` activé globalement
- ✅ Tokens CSRF automatiques sur tous les formulaires
- ✅ Vérification stricte des requêtes POST/PUT/DELETE

### 3. Headers de sécurité

Headers HTTP sécurisés configurés dans `Securable` concern:

```ruby
X-Frame-Options: SAMEORIGIN           # Protection contre clickjacking
X-Content-Type-Options: nosniff       # Prévention MIME sniffing
X-XSS-Protection: 1; mode=block       # Protection XSS basique
Referrer-Policy: strict-origin-when-cross-origin
```

### 4. Validation des données

#### Modèle User
- Username: 3-30 caractères, alphanumérique + underscore uniquement
- Email: validation Devise + unicité
- URLs: validation de format HTTP/HTTPS
- Zipcode: exactement 5 chiffres
- Niveau: plafonné à 100

#### Modèle Project
- Titre: 3-100 caractères
- Description: max 2000 caractères
- Max members: 1-50
- Dates: validation cohérence (end_date > start_date)
- Status/Visibility: valeurs limitées aux constantes

#### Modèle Message
- Contenu: 1-1000 caractères
- Sender: vérifié automatiquement (current_user)

### 5. Protection contre les injections

- ✅ **SQL Injection**: Utilisation exclusive de l'ORM ActiveRecord
- ✅ **XSS**: ERB échappe automatiquement le HTML
- ✅ **Mass Assignment**: Strong parameters obligatoires

### 6. Gestion des erreurs

- ✅ Rescue des `RecordNotFound` → redirection sécurisée
- ✅ Rescue des `ParameterMissing` → message d'erreur explicite
- ✅ Messages d'erreur sans divulgation d'information sensible

### 7. Contrôles d'accès

#### ProjectsController
```ruby
before_action :authorize_owner!, only: [:edit, :update, :destroy]
```
- Seul le créateur peut modifier/supprimer un projet
- Seuls les membres peuvent accéder aux messages

#### MessagesController
```ruby
before_action :authorize_member!
```
- Vérification de l'appartenance au projet avant accès

#### UserSkillsController
```ruby
@user_skill = current_user.user_skills.find(params[:id])
```
- Un user ne peut modifier que ses propres skills

### 8. Sécurité des associations

- ✅ Contraintes de clés étrangères en base
- ✅ Index uniques pour éviter doublons (user_id + skill_id, etc.)
- ✅ Dependent destroy pour éviter orphelins

### 9. Validations métier

- Un user ne peut pas avoir 2x la même skill
- Un user ne peut pas rejoindre 2x le même projet
- Un projet ne peut pas dépasser max_members
- Le créateur d'un projet ne peut pas le quitter

### 10. Tests de sécurité

- ✅ Tests RSpec sur validations
- ✅ Tests sur scopes et méthodes métier
- ✅ Factories pour tests cohérents

## Recommandations futures

### Court terme
1. ⚠️ Ajouter rate limiting (rack-attack)
2. ⚠️ Logger les tentatives d'accès non autorisé
3. ⚠️ Ajouter confirmation email (Devise :confirmable)
4. ⚠️ Implémenter 2FA pour comptes admin

### Moyen terme
1. Audit de sécurité avec Brakeman
2. Scan de dépendances avec bundler-audit
3. HTTPS obligatoire en production
4. CSP (Content Security Policy)

### Long terme
1. Pentest professionnel
2. Bug bounty program
3. Certification ISO 27001

## Signaler une vulnérabilité

Si vous découvrez une faille de sécurité, contactez:
- Email: security@nexp.dev (à créer)
- Ne pas créer d'issue publique

## Dernière révision

Date: 2026-01-13
Révisé par: Claude Code Audit
