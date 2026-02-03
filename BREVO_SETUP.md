# 📧 GUIDE COMPLET - CONFIGURATION BREVO

## ✅ CE QUI EST FAIT

1. ✅ Configuration SMTP production (Brevo-ready)
2. ✅ Email de confirmation personnalisé avec design NexP
3. ✅ letter_opener installé pour tester en local
4. ✅ Configuration development pour preview emails

---

## 🎯 ÉTAPES POUR CONFIGURER BREVO

### 1️⃣ Créer votre compte Brevo

1. Aller sur https://www.brevo.com/fr/
2. Cliquer sur "S'inscrire gratuitement"
3. Créer votre compte (300 emails/jour gratuits)
4. Confirmer votre email

### 2️⃣ Obtenir vos clés SMTP

**Dans votre compte Brevo** :
1. Cliquer sur votre nom (en haut à droite)
2. Aller dans **"Paramètres"** (Settings)
3. Dans le menu de gauche → **"SMTP & API"**
4. Onglet **"SMTP"**
5. Cliquer sur **"Créer une clé SMTP"** ou **"Générer une nouvelle clé SMTP"**
6. **COPIER LA CLÉ** (format: `xsmtpsib-xxxxxxxxxxxxx`)
   ⚠️ Vous ne pourrez plus la revoir après !

**Vos identifiants Brevo** :
```
Serveur:       smtp-relay.brevo.com
Port:          587
Login:         votre-email@example.com (email de votre compte Brevo)
Mot de passe:  xsmtpsib-xxxxxxxxxxxxx (la clé SMTP générée)
```

---

## 🧪 TESTER EN LOCAL (Development)

### Option 1: letter_opener (déjà configuré ✅)

Les emails s'ouvrent automatiquement dans votre navigateur !

**Test rapide** :
```bash
# Démarrer le serveur Rails
bin/rails server

# Dans un autre terminal, créer un utilisateur
bin/rails console
> user = User.create!(
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123'
  )
> user.send_confirmation_instructions
```

➡️ Un onglet s'ouvrira dans votre navigateur avec l'email !

### Option 2: Tester avec vrai SMTP Brevo en dev

**Modifier temporairement** `config/environments/development.rb`:
```ruby
# Remplacer letter_opener par :
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp-relay.brevo.com',
  port: 587,
  user_name: 'votre-email@example.com',
  password: 'xsmtpsib-votre-cle',
  authentication: :plain,
  enable_starttls_auto: true
}
```

---

## 🚀 CONFIGURATION PRODUCTION

### Variables d'environnement à définir

**Sur votre serveur de production** (Heroku, Render, etc.):

```bash
# Rails
export RAILS_MASTER_KEY="61c2fd80faa4dd2e5e0e833103185f2b"
export RAILS_ENV="production"

# Application
export APP_HOST="votre-domaine.com"

# Brevo SMTP
export SMTP_ADDRESS="smtp-relay.brevo.com"
export SMTP_PORT="587"
export SMTP_USERNAME="votre-email@example.com"
export SMTP_PASSWORD="xsmtpsib-xxxxxxxxxxxxx"
export SMTP_DOMAIN="votre-domaine.com"

# Base de données
export NEX_P_DATABASE_PASSWORD="votre-db-password"
```

### Exemple avec Heroku

```bash
# Définir les variables
heroku config:set RAILS_MASTER_KEY="61c2fd80faa4dd2e5e0e833103185f2b"
heroku config:set APP_HOST="nexp.herokuapp.com"
heroku config:set SMTP_ADDRESS="smtp-relay.brevo.com"
heroku config:set SMTP_PORT="587"
heroku config:set SMTP_USERNAME="votre@email.com"
heroku config:set SMTP_PASSWORD="xsmtpsib-xxxxx"
heroku config:set SMTP_DOMAIN="nexp.herokuapp.com"

# Vérifier
heroku config
```

---

## 🧪 TESTER EN PRODUCTION

### Test 1: Console Rails production

```bash
# Se connecter en console production
heroku run rails console -a votre-app
# ou
bin/rails console -e production

# Créer un utilisateur de test
user = User.create!(
  email: 'test@votre-domaine.com',
  username: 'testprod',
  password: 'SecurePassword123!'
)

# Envoyer l'email de confirmation
user.send_confirmation_instructions

# Vérifier dans les logs Brevo
```

### Test 2: S'inscrire via l'interface

1. Aller sur votre site production
2. Cliquer sur "S'inscrire"
3. Remplir le formulaire
4. ✅ Vous devriez recevoir l'email de confirmation !

---

## 📊 DASHBOARD BREVO

**Suivre vos envois** :
1. Aller sur https://app.brevo.com
2. Menu **"Statistiques"** → **"Emails transactionnels"**
3. Vous verrez :
   - Nombre d'emails envoyés
   - Taux d'ouverture
   - Taux de clics
   - Bounces / Spam

---

## ⚠️ TROUBLESHOOTING

### Problème 1: Email non reçu

**Vérifications** :
- ✅ Vérifier que les variables d'environnement sont bien définies
- ✅ Vérifier dans les logs Brevo (Dashboard → Logs)
- ✅ Vérifier dans les SPAM de votre boîte mail
- ✅ Vérifier que votre domaine n'est pas blacklisté

### Problème 2: Erreur SMTP

**Logs à vérifier** :
```bash
# Voir les logs production
heroku logs --tail -a votre-app

# Rechercher les erreurs SMTP
heroku logs --tail | grep -i smtp
```

**Erreurs courantes** :
- `535 Authentication failed` → Mot de passe SMTP incorrect
- `Invalid credentials` → Vérifier SMTP_USERNAME et SMTP_PASSWORD
- `Connection timeout` → Firewall bloque le port 587

### Problème 3: Email marqué comme SPAM

**Solutions** :
1. Configurer SPF record pour votre domaine
2. Configurer DKIM (dans Brevo → Paramètres → Domaines)
3. Ajouter un domaine vérifié dans Brevo
4. Éviter les mots "spam" dans l'email (promotion, gratuit, etc.)

---

## 📋 CHECKLIST FINALE

Avant de déployer en production :

- [ ] Compte Brevo créé et vérifié
- [ ] Clé SMTP générée et sauvegardée
- [ ] Variables d'environnement configurées sur le serveur
- [ ] Email de confirmation testé en local avec letter_opener
- [ ] Email testé en production (console ou inscription réelle)
- [ ] Email bien reçu (pas dans SPAM)
- [ ] Dashboard Brevo montre l'email envoyé
- [ ] Lien de confirmation fonctionne

---

**✅ Une fois tout configuré, vos utilisateurs recevront automatiquement un email de confirmation à l'inscription !**
