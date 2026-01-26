import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Connected to NotificationChannel")
  },

  disconnected() {
    console.log("Disconnected from NotificationChannel")
  },

  received(data) {
    // Mettre à jour le compteur de notifications
    this.updateNotificationBadge(data.unread_count)

    // Afficher une notification toast
    this.showNotificationToast(data)
  },

  updateNotificationBadge(count) {
    const badge = document.querySelector('[data-notifications-target="badge"]')
    if (badge) {
      if (count > 0) {
        badge.textContent = count > 99 ? '99+' : count
        badge.classList.remove('hidden')
      } else {
        badge.classList.add('hidden')
      }
    }
  },

  showNotificationToast(data) {
    // Créer un élément de notification temporaire
    const toast = document.createElement('div')
    toast.className = 'fixed top-20 right-6 bg-card border border-border rounded-lg shadow-lg p-4 max-w-sm z-50 animate-fade-in-up'
    toast.innerHTML = `
      <div class="flex items-start gap-3">
        <div class="w-10 h-10 bg-primary text-primary-foreground rounded-full flex items-center justify-center font-bold flex-shrink-0">
          ${data.actor_name[0].toUpperCase()}
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-semibold text-foreground">${data.actor_name}</p>
          <p class="text-sm text-muted-foreground">${data.message}</p>
        </div>
        <button onclick="this.parentElement.parentElement.remove()" class="text-muted-foreground hover:text-foreground">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
    `

    document.body.appendChild(toast)

    // Retirer après 5 secondes
    setTimeout(() => {
      toast.style.opacity = '0'
      toast.style.transition = 'opacity 0.3s'
      setTimeout(() => toast.remove(), 300)
    }, 5000)
  }
});
