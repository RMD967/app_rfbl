import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "video", "playIndicator", "volumeIcon", "feedViewport"]

  connect() {
    this.isMuted = true
    this.setupIntersectionObserver()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  setupIntersectionObserver() {
    const options = {
      root: this.hasFeedViewportTarget ? this.feedViewportTarget : null,
      threshold: 0.65
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const video = entry.target.querySelector("video")
        if (!video) return

        if (entry.isIntersecting) {
          // Play current video
          video.muted = this.isMuted
          const playPromise = video.play()
          if (playPromise !== undefined) {
            playPromise.catch((err) => {
              // Browser autoplay policy blocked audio, ensure muted
              video.muted = true
              video.play().catch(() => {})
            })
          }
        } else {
          // Pause when scrolled away
          video.pause()
          video.currentTime = 0
        }
      })
    }, options)

    this.cardTargets.forEach((card) => {
      this.observer.observe(card)
    })
  }

  togglePlay(event) {
    const video = event.currentTarget
    const card = video.closest(".tiktok-card")
    const indicator = card.querySelector(".tiktok-play-indicator")

    if (video.paused) {
      video.play()
      if (indicator) {
        indicator.classList.remove("visible")
      }
    } else {
      video.pause()
      if (indicator) {
        indicator.classList.add("visible")
      }
    }
  }

  toggleMute(event) {
    event.stopPropagation()
    this.isMuted = !this.isMuted

    this.videoTargets.forEach((video) => {
      video.muted = this.isMuted
    })

    this.volumeIconTargets.forEach((icon) => {
      if (this.isMuted) {
        icon.className = "ri-volume-mute-fill"
      } else {
        icon.className = "ri-volume-up-fill text-warning"
      }
    })
  }

  openComments(event) {
    event.preventDefault()
    event.stopPropagation()
    const discoverId = event.currentTarget.dataset.discoverId
    const drawer = document.getElementById(`comments_drawer_${discoverId}`)
    if (drawer) {
      drawer.classList.add("open")
    }
  }

  closeComments(event) {
    event.preventDefault()
    event.stopPropagation()
    const discoverId = event.currentTarget.dataset.discoverId
    if (discoverId) {
      const drawer = document.getElementById(`comments_drawer_${discoverId}`)
      if (drawer) drawer.classList.remove("open")
    } else {
      const openDrawers = document.querySelectorAll(".tiktok-comments-drawer.open")
      openDrawers.forEach((drawer) => drawer.classList.remove("open"))
    }
  }

  startReply(event) {
    event.preventDefault()
    event.stopPropagation()

    const btn = event.currentTarget
    const commentId = btn.dataset.commentId
    const authorName = btn.dataset.authorName
    const discoverId = btn.dataset.discoverId

    const parentInput = document.getElementById(`discover_${discoverId}_parent_id`)
    const replyIndicator = document.getElementById(`discover_${discoverId}_reply_indicator`)
    const replyName = document.getElementById(`discover_${discoverId}_reply_name`)
    const commentInput = document.getElementById(`discover_${discoverId}_comment_input`)

    if (parentInput) parentInput.value = commentId
    if (replyName) replyName.textContent = authorName
    if (replyIndicator) replyIndicator.classList.remove("d-none")
    if (commentInput) {
      commentInput.placeholder = `Respondiendo a @${authorName}...`
      commentInput.focus()
    }
  }

  cancelReply(event) {
    event.preventDefault()
    event.stopPropagation()

    const discoverId = event.currentTarget.dataset.discoverId
    const parentInput = document.getElementById(`discover_${discoverId}_parent_id`)
    const replyIndicator = document.getElementById(`discover_${discoverId}_reply_indicator`)
    const commentInput = document.getElementById(`discover_${discoverId}_comment_input`)

    if (parentInput) parentInput.value = ""
    if (replyIndicator) replyIndicator.classList.add("d-none")
    if (commentInput) {
      commentInput.placeholder = "Agrega un comentario..."
    }
  }

  onCommentSubmitted(event) {
    const form = event.currentTarget
    const card = form.closest(".tiktok-card")
    if (!card) return
    const discoverId = card.dataset.videoId

    const parentInput = document.getElementById(`discover_${discoverId}_parent_id`)
    const replyIndicator = document.getElementById(`discover_${discoverId}_reply_indicator`)
    const commentInput = document.getElementById(`discover_${discoverId}_comment_input`)

    if (parentInput) parentInput.value = ""
    if (replyIndicator) replyIndicator.classList.add("d-none")
    if (commentInput) {
      commentInput.value = ""
      commentInput.placeholder = "Agrega un comentario..."
    }
  }
}
