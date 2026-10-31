import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "banner",
    "statusPill",
    "enableBtn",
    "testBtn",
    "toast"
  ]

  connect() {
    this.isSupported = "Notification" in window
    this.registerServiceWorker()
    this.updateStatusUI()
  }

  registerServiceWorker() {
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("/serviceworker.js").catch((err) => {
        console.warn("ServiceWorker registration deferred:", err)
      })
    }
  }

  updateStatusUI() {
    if (!this.isSupported) {
      if (this.hasStatusPillTarget) {
        this.statusPillTarget.innerHTML = '<i class="ri-close-circle-line text-secondary"></i> <span>No soportado</span>'
      }
      if (this.hasBannerTarget) {
        this.bannerTarget.classList.add("d-none")
      }
      return
    }

    const permission = Notification.permission

    if (permission === "granted") {
      if (this.hasStatusPillTarget) {
        this.statusPillTarget.className = "activity-push-status-pill granted"
        this.statusPillTarget.innerHTML = '<i class="ri-notification-badge-fill text-success"></i> <span>Push Activo</span>'
      }
      if (this.hasEnableBtnTarget) {
        this.enableBtnTarget.classList.add("d-none")
      }
      if (this.hasTestBtnTarget) {
        this.testBtnTarget.classList.remove("d-none")
      }
      // If previously dismissed or already granted, keep banner compact
      const dismissed = localStorage.getItem("rfbl_push_banner_dismissed")
      if (dismissed === "true" && this.hasBannerTarget) {
        this.bannerTarget.classList.add("compact")
      }
    } else if (permission === "denied") {
      if (this.hasStatusPillTarget) {
        this.statusPillTarget.className = "activity-push-status-pill denied"
        this.statusPillTarget.innerHTML = '<i class="ri-notification-off-fill text-danger"></i> <span>Bloqueado</span>'
      }
      if (this.hasEnableBtnTarget) {
        this.enableBtnTarget.textContent = "Permisos bloqueados en navegador"
        this.enableBtnTarget.disabled = true
      }
      if (this.hasTestBtnTarget) {
        this.testBtnTarget.classList.add("d-none")
      }
    } else {
      // Default: promptable
      if (this.hasStatusPillTarget) {
        this.statusPillTarget.className = "activity-push-status-pill default"
        this.statusPillTarget.innerHTML = '<i class="ri-notification-3-line text-warning"></i> <span>Activar Push</span>'
      }
      if (this.hasEnableBtnTarget) {
        this.enableBtnTarget.classList.remove("d-none")
      }
      if (this.hasTestBtnTarget) {
        this.testBtnTarget.classList.add("d-none")
      }
    }
  }

  async requestPermission(event) {
    if (event) event.preventDefault()

    if (!this.isSupported) {
      this.showToast("Tu navegador no soporta notificaciones push.")
      return
    }

    try {
      const permission = await Notification.requestPermission()
      this.updateStatusUI()

      if (permission === "granted") {
        this.showToast("🔔 ¡Notificaciones push activadas con éxito!")
        this.dispatchNotification(
          "Radios FBL - ¡Notificaciones activadas!",
          "Recibirás alertas de nuevos posts de tus artistas seguidos, mensajes de chat y eventos.",
          "/activity"
        )
      } else if (permission === "denied") {
        this.showToast("Notificaciones bloqueadas en la configuración de tu navegador.")
      }
    } catch (e) {
      console.error("Error requesting notification permission:", e)
    }
  }

  sendTestNotification(event) {
    if (event) event.preventDefault()

    if (!this.isSupported || Notification.permission !== "granted") {
      this.requestPermission()
      return
    }

    const sampleNotifications = [
      {
        title: "🎵 Nuevo post de Sonora Tropical Angelópolis",
        body: "Acaban de publicar 'Cumbia Sabrosa en Cholula'. ¡Toca para escuchar en el feed!",
        url: "/discovers"
      },
      {
        title: "💬 Nuevo mensaje de Sarah Jenkins",
        body: "Te envió un mensaje en el chatroom 'The Skyline Rooftop Lounge'.",
        url: "/chatrooms"
      },
      {
        title: "🎟️ Postulación confirmada: Noche de Salsa & Cumbia",
        body: "El organizador ha confirmado tu participación como artista.",
        url: "/activity?category=bookings"
      }
    ]

    const sample = sampleNotifications[Math.floor(Math.random() * sampleNotifications.length)]
    this.dispatchNotification(sample.title, sample.body, sample.url)
    this.showToast("🔔 Notificación de prueba enviada.")
  }

  dispatchNotification(title, body, url) {
    const iconUrl = "https://i.postimg.cc/76tbpCkS/Copy-of-Clean-Modern-App-Portfolio-Mockup-Presentation-2.png"

    if ("serviceWorker" in navigator && navigator.serviceWorker.controller) {
      navigator.serviceWorker.ready.then((registration) => {
        registration.showNotification(title, {
          body: body,
          icon: iconUrl,
          badge: iconUrl,
          data: { url: url },
          vibrate: [200, 100, 200],
          tag: "rfbl-push-" + Date.now()
        })
      })
    } else {
      // Fallback native Notification instance
      try {
        const notif = new Notification(title, {
          body: body,
          icon: iconUrl,
          badge: iconUrl,
          vibrate: [200, 100, 200],
          tag: "rfbl-push-" + Date.now()
        })
        notif.onclick = () => {
          window.focus()
          window.location.href = url
          notif.close()
        }
      } catch (err) {
        console.warn("Direct notification creation failed:", err)
      }
    }
  }

  dismissBanner(event) {
    if (event) event.preventDefault()
    if (this.hasBannerTarget) {
      this.bannerTarget.classList.add("d-none")
      localStorage.setItem("rfbl_push_banner_dismissed", "true")
    }
  }

  showToast(message) {
    if (!this.hasToastTarget) return
    this.toastTarget.textContent = message
    this.toastTarget.classList.remove("d-none")
    this.toastTarget.classList.add("visible")
    clearTimeout(this.toastTimeout)
    this.toastTimeout = setTimeout(() => {
      this.toastTarget.classList.remove("visible")
      setTimeout(() => this.toastTarget.classList.add("d-none"), 300)
    }, 2800)
  }
}
