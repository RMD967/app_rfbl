import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    this.tracked = false
    this.watchedSeconds = 0

    const video = this.element.tagName === "VIDEO" ? this.element : this.element.querySelector("video")
    const iframe = this.element.querySelector("iframe")

    if (video) {
      this.video = video
      this.bindVideo(video)
    } else if (iframe) {
      this.iframe = iframe
      this.bindIframe(iframe)
    }
  }

  disconnect() {
    this.stopIframeTimer()
    if (this.video && this.timeUpdateHandler) {
      this.video.removeEventListener("timeupdate", this.timeUpdateHandler)
    }
    if (this.messageHandler) {
      window.removeEventListener("message", this.messageHandler)
    }
  }

  bindVideo(video) {
    this.timeUpdateHandler = () => {
      if (this.tracked) return

      // Watched >= 5 seconds
      if (video.currentTime >= 5.0) {
        this.trackPlay(video.currentTime)
      }
    }
    video.addEventListener("timeupdate", this.timeUpdateHandler)
  }

  bindIframe(iframe) {
    this.messageHandler = (event) => {
      if (this.tracked) return
      let data = event.data
      if (typeof data === "string") {
        try {
          data = JSON.parse(data)
        } catch (e) {
          return
        }
      }

      if (data && data.event === "onStateChange") {
        if (data.info === 1) { // Playing
          this.startIframeTimer()
        } else {
          this.stopIframeTimer()
        }
      } else if (data && data.info && typeof data.info.currentTime === "number") {
        if (data.info.currentTime >= 5.0) {
          this.trackPlay(data.info.currentTime)
        }
      }
    }

    window.addEventListener("message", this.messageHandler)

    // Fallback: If user hovers / clicks into iframe, ask YouTube for postMessage API events
    this.element.addEventListener("click", () => {
      this.startIframeTimer()
    }, { once: true })
  }

  startIframeTimer() {
    if (this.ytTimer || this.tracked) return
    this.ytTimer = setInterval(() => {
      this.watchedSeconds += 1
      if (this.watchedSeconds >= 5) {
        this.trackPlay(this.watchedSeconds)
        this.stopIframeTimer()
      }
    }, 1000)
  }

  stopIframeTimer() {
    if (this.ytTimer) {
      clearInterval(this.ytTimer)
      this.ytTimer = null
    }
  }

  async trackPlay(duration) {
    if (this.tracked || !this.urlValue) return
    this.tracked = true

    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken || ""
        },
        body: JSON.stringify({ duration: duration })
      })

      if (response.ok) {
        const data = await response.json()
        if (data.plays !== undefined) {
          const card = this.element.closest(".artist-post-card") || this.element.closest(".tiktok-card")
          const playsDisplay = card?.querySelector(".plays-value")
          if (playsDisplay) {
            playsDisplay.textContent = data.plays
          }
        }
      }
    } catch (err) {
      console.warn("Error tracking play:", err)
    }
  }
}
