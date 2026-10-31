import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "video", "playIndicator", "volumeIcon", "feedViewport"]

  connect() {
    this.isMuted = true
    this.setupIntersectionObserver()

    // Autoplay the first visible video as soon as the DOM is ready
    setTimeout(() => {
      this.playFirstVideo()
    }, 150)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  playFirstVideo() {
    if (this.videoTargets.length > 0) {
      const firstVideo = this.videoTargets[0]
      this.playVideo(firstVideo)
    }
  }

  setupIntersectionObserver() {
    // Low threshold (0.25) so videos reliably trigger autoplay on any screen size
    const options = {
      root: this.hasFeedViewportTarget ? this.feedViewportTarget : null,
      threshold: 0.25
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const video = entry.target.querySelector("video")
        if (!video) return

        if (entry.isIntersecting && entry.intersectionRatio >= 0.25) {
          this.playVideo(video)
        } else {
          this.pauseVideo(video)
        }
      })
    }, options)

    this.cardTargets.forEach((card) => {
      this.observer.observe(card)
    })
  }

  playVideo(video) {
    // Pause other videos
    this.videoTargets.forEach((v) => {
      if (v !== video) {
        v.pause()
        const card = v.closest(".tiktok-card")
        const indicator = card?.querySelector(".tiktok-play-indicator")
        if (indicator) indicator.classList.remove("visible")
      }
    })

    video.muted = this.isMuted
    const playPromise = video.play()
    if (playPromise !== undefined) {
      playPromise.catch((err) => {
        // Autoplay policy prevented playback, ensure muted and retry
        video.muted = true
        video.play().catch(() => {
          // If still blocked by browser policy without gesture, show play indicator
          const card = video.closest(".tiktok-card")
          const indicator = card?.querySelector(".tiktok-play-indicator")
          if (indicator) indicator.classList.add("visible")
        })
      })
    }

    const card = video.closest(".tiktok-card")
    const indicator = card?.querySelector(".tiktok-play-indicator")
    if (indicator) indicator.classList.remove("visible")
  }

  pauseVideo(video) {
    video.pause()
    const card = video.closest(".tiktok-card")
    const indicator = card?.querySelector(".tiktok-play-indicator")
    if (indicator) indicator.classList.remove("visible")
  }

  togglePlay(event) {
    event.preventDefault()
    event.stopPropagation()
    const video = event.currentTarget
    const card = video.closest(".tiktok-card")
    const indicator = card?.querySelector(".tiktok-play-indicator")

    if (video.paused) {
      this.playVideo(video)
      if (indicator) indicator.classList.remove("visible")
    } else {
      video.pause()
      if (indicator) indicator.classList.add("visible")
    }
  }

  onIndicatorClick(event) {
    event.preventDefault()
    event.stopPropagation()
    const card = event.currentTarget.closest(".tiktok-card")
    const video = card?.querySelector("video")
    if (video) {
      this.playVideo(video)
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
    const target = event.currentTarget
    const discoverId = target.dataset.discoverId || target.closest("[data-discover-id]")?.dataset.discoverId
    const drawer = document.getElementById(`comments_drawer_${discoverId}`)
    if (drawer) {
      drawer.classList.add("open")
    }
  }

  closeComments(event) {
    event.preventDefault()
    event.stopPropagation()
    const target = event.currentTarget
    const discoverId = target.dataset.discoverId || target.closest("[data-discover-id]")?.dataset.discoverId
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
    const discoverId = btn.dataset.discoverId || btn.closest("[data-discover-id]")?.dataset.discoverId

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

    const target = event.currentTarget
    const discoverId = target.dataset.discoverId || target.closest("[data-discover-id]")?.dataset.discoverId
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
    const discoverId = card?.dataset.discoverId || card?.dataset.videoId || form.id.match(/\d+/)?.[0]

    if (discoverId) {
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
}
