import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "card",
    "video",
    "playIndicator",
    "volumeIcon",
    "feedViewport",
    "toast",
    "optionsBackdrop",
    "optionsSheet",
    "clearScreenSwitch",
    "autoScrollSwitch",
    "speedPill",
    "exitClearScreenBtn",
    "pullRefreshIndicator",
    "pullRefreshSpinner",
    "pullRefreshIcon",
    "pullRefreshText",
    "headerRefreshIcon",
    "uploadBackdrop",
    "uploadModal",
    "sourceLinkBtn",
    "sourceFileBtn",
    "linkSection",
    "fileSection",
    "linkInput",
    "fileInput",
    "dropzoneText",
    "youtubePreview"
  ]

  connect() {
    this.isMuted = false
    this.userMutedManually = false

    // Pull to refresh tracking
    this.pullStartY = 0
    this.pullDistance = 0
    this.isPullRefreshing = false
    this.isEligibleForPull = false
    this.pullThreshold = 75

    // Load persisted video preferences
    this.isClearScreen = localStorage.getItem("rfbl_clear_screen") === "true"
    this.isAutoScroll = localStorage.getItem("rfbl_auto_scroll") === "true"
    const savedSpeedStr = localStorage.getItem("rfbl_playback_speed")
    this.savedSpeed = savedSpeedStr ? parseFloat(savedSpeedStr) : 1.0

    // Touch & long-press tracking
    this.longPressTimeout = null
    this.touchStartX = 0
    this.touchStartY = 0
    this.isLongPressTriggered = false

    // Apply persisted states
    this.applyClearScreen(this.isClearScreen)
    this.applyAutoScroll(this.isAutoScroll)
    this.applySpeedUI(this.savedSpeed)

    this.setupIntersectionObserver()

    // Desktop mouse wheel scroll-up at top of feed to refresh
    if (this.hasFeedViewportTarget) {
      this.onWheelHandler = (e) => {
        if (this.feedViewportTarget.scrollTop <= 0 && e.deltaY < -45 && !this.isPullRefreshing) {
          this.triggerPullRefresh()
        }
      }
      this.feedViewportTarget.addEventListener("wheel", this.onWheelHandler, { passive: true })
    }

    // Attempt to unmute active videos on user interaction if browser policy deferred audio
    const firstInteraction = () => {
      if (!this.userMutedManually) {
        this.unmuteAll()
      }
      window.removeEventListener("click", firstInteraction, true)
      window.removeEventListener("touchstart", firstInteraction, true)
      window.removeEventListener("keydown", firstInteraction, true)
    }
    window.addEventListener("click", firstInteraction, true)
    window.addEventListener("touchstart", firstInteraction, true)
    window.addEventListener("keydown", firstInteraction, true)

    // Autoplay the first visible video as soon as the DOM is ready
    setTimeout(() => {
      this.playFirstVideo()
    }, 150)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
    if (this.longPressTimeout) {
      clearTimeout(this.longPressTimeout)
    }
    if (this.hasFeedViewportTarget && this.onWheelHandler) {
      this.feedViewportTarget.removeEventListener("wheel", this.onWheelHandler)
    }
    document.body.classList.remove("clear-screen-active")
  }

  playFirstVideo() {
    if (this.videoTargets.length > 0) {
      const firstVideo = this.videoTargets[0]
      this.playVideo(firstVideo)
    }
  }

  setupIntersectionObserver() {
    const options = {
      root: this.hasFeedViewportTarget ? this.feedViewportTarget : null,
      threshold: 0.6
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const video = entry.target.querySelector("video")
        const iframe = entry.target.querySelector("iframe.tiktok-youtube-iframe")

        if (entry.isIntersecting && entry.intersectionRatio >= 0.6) {
          if (video) this.playVideo(video)
        } else if (!entry.isIntersecting || entry.intersectionRatio < 0.25) {
          if (video) this.pauseVideo(video)
          if (iframe && iframe.contentWindow) {
            try {
              iframe.contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', "*")
            } catch (err) {}
          }
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
    video.playbackRate = this.savedSpeed || 1.0
    if (this.isAutoScroll) {
      video.loop = false
      video.removeAttribute("loop")
    } else {
      video.loop = true
      video.setAttribute("loop", "loop")
    }
    video._autoScrolled = false

    const playPromise = video.play()
    if (playPromise !== undefined) {
      playPromise.catch((err) => {
        video.muted = true
        video.play().catch(() => {
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
    // If a long press just triggered, prevent the click from toggling play/pause
    if (this.isLongPressTriggered) {
      this.isLongPressTriggered = false
      event.preventDefault()
      event.stopPropagation()
      return
    }

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
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }

    if (this.isMuted) {
      this.unmuteAll()
      this.showToast("🔊 Sonido activado")
    } else {
      this.muteAll()
      this.showToast("🔇 Sonido silenciado")
    }
  }

  unmuteAll() {
    this.isMuted = false
    this.userMutedManually = false
    this.videoTargets.forEach((video) => {
      video.muted = false
    })
    this.updateVolumeIcons()
  }

  muteAll() {
    this.isMuted = true
    this.userMutedManually = true
    this.videoTargets.forEach((video) => {
      video.muted = true
    })
    this.updateVolumeIcons()
  }

  updateVolumeIcons() {
    this.volumeIconTargets.forEach((icon) => {
      const btn = icon.closest(".tiktok-sound-toggle")
      if (this.isMuted) {
        icon.className = "ri-volume-mute-fill"
        btn?.classList.remove("sound-active")
      } else {
        icon.className = "ri-volume-up-fill"
        btn?.classList.add("sound-active")
      }
    })
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
    }, 1400)
  }

  // ---------------- Long Press & Right-Click Options Menu ----------------

  onContextMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    this.openOptionsMenu(event.currentTarget)
  }

  onTouchStart(event) {
    if (event.touches.length !== 1) return
    // Don't trigger if touching inside comments drawer, interactive button or link
    if (event.target.closest("button, a, input, .tiktok-comments-drawer, .tiktok-options-sheet")) return

    this.touchStartX = event.touches[0].clientX
    this.touchStartY = event.touches[0].clientY
    this.isLongPressTriggered = false

    // Check if user is at the top of the feed to allow pull-to-refresh
    const scrollTop = this.hasFeedViewportTarget ? this.feedViewportTarget.scrollTop : 0
    this.isEligibleForPull = scrollTop <= 8
    this.pullStartY = event.touches[0].clientY

    clearTimeout(this.longPressTimeout)
    this.longPressTimeout = setTimeout(() => {
      this.isLongPressTriggered = true
      if (navigator.vibrate) navigator.vibrate(40)
      this.openOptionsMenu(event.currentTarget)
    }, 450)
  }

  onTouchMove(event) {
    const touch = event.touches[0]
    const deltaX = Math.abs(touch.clientX - this.touchStartX)
    const diffY = touch.clientY - this.pullStartY
    const deltaY = Math.abs(diffY)

    // If finger moves more than 10px, it's a scroll gesture, cancel long press
    if (deltaX > 10 || deltaY > 10) {
      clearTimeout(this.longPressTimeout)
      this.longPressTimeout = null
    }

    // Pull-to-refresh gesture tracking when pulling down at the top of the feed
    if (this.isEligibleForPull && diffY > 8 && !this.isPullRefreshing) {
      this.pullDistance = Math.min(diffY * 0.45, 110)

      if (this.hasPullRefreshIndicatorTarget) {
        this.pullRefreshIndicatorTarget.classList.add("visible")
        this.pullRefreshIndicatorTarget.style.transform = `translate(-50%, ${this.pullDistance}px)`

        if (diffY >= this.pullThreshold) {
          if (this.hasPullRefreshTextTarget) {
            this.pullRefreshTextTarget.textContent = "Suelta para actualizar"
          }
          if (this.hasPullRefreshIconTarget) {
            this.pullRefreshIconTarget.className = "ri-refresh-line pull-refresh-icon rotating-ready"
          }
        } else {
          if (this.hasPullRefreshTextTarget) {
            this.pullRefreshTextTarget.textContent = "Desliza para actualizar"
          }
          if (this.hasPullRefreshIconTarget) {
            this.pullRefreshIconTarget.className = "ri-arrow-down-line pull-refresh-icon"
          }
        }
      }
    }
  }

  onTouchEnd(event) {
    clearTimeout(this.longPressTimeout)
    this.longPressTimeout = null

    if (this.isEligibleForPull && !this.isPullRefreshing) {
      const touchEnd = event.changedTouches[0]
      const diffY = touchEnd ? (touchEnd.clientY - this.pullStartY) : 0

      if (diffY >= this.pullThreshold) {
        this.triggerPullRefresh()
      } else {
        this.resetPullIndicator()
      }
    }
    this.isEligibleForPull = false
  }

  onTouchCancel(event) {
    clearTimeout(this.longPressTimeout)
    this.longPressTimeout = null
    this.resetPullIndicator()
    this.isEligibleForPull = false
  }

  triggerPullRefresh() {
    if (this.isPullRefreshing) return
    this.isPullRefreshing = true

    if (this.hasPullRefreshIndicatorTarget) {
      this.pullRefreshIndicatorTarget.classList.add("visible", "refreshing")
      this.pullRefreshIndicatorTarget.style.transform = "translate(-50%, 65px)"
    }
    if (this.hasPullRefreshTextTarget) {
      this.pullRefreshTextTarget.textContent = "Actualizando videos..."
    }
    if (this.hasPullRefreshIconTarget) {
      this.pullRefreshIconTarget.className = "ri-refresh-line pull-refresh-icon is-spinning"
    }
    if (this.hasHeaderRefreshIconTarget) {
      this.headerRefreshIconTarget.classList.add("is-spinning")
    }
    if (navigator.vibrate) {
      navigator.vibrate(50)
    }

    setTimeout(() => {
      const url = new URL(window.location.href)
      url.searchParams.set("refresh", Date.now())
      window.location.href = url.toString()
    }, 400)
  }

  resetPullIndicator() {
    if (!this.hasPullRefreshIndicatorTarget || this.isPullRefreshing) return
    this.pullRefreshIndicatorTarget.style.transform = "translate(-50%, -60px)"
    setTimeout(() => {
      if (!this.isPullRefreshing && this.hasPullRefreshIndicatorTarget) {
        this.pullRefreshIndicatorTarget.classList.remove("visible", "refreshing")
      }
    }, 220)
  }

  onRefreshClick(event) {
    if (this.hasHeaderRefreshIconTarget) {
      this.headerRefreshIconTarget.classList.add("is-spinning")
    }
  }

  openOptionsMenu(card = null) {
    this.updateOptionsModalUI()

    if (this.hasOptionsBackdropTarget) {
      this.optionsBackdropTarget.classList.remove("d-none")
      void this.optionsBackdropTarget.offsetWidth // force layout
      this.optionsBackdropTarget.classList.add("visible")
    }
    if (this.hasOptionsSheetTarget) {
      this.optionsSheetTarget.classList.add("open")
    }
  }

  closeOptionsMenu() {
    if (this.hasOptionsSheetTarget) {
      this.optionsSheetTarget.classList.remove("open")
    }
    if (this.hasOptionsBackdropTarget) {
      this.optionsBackdropTarget.classList.remove("visible")
      setTimeout(() => {
        if (!this.optionsBackdropTarget.classList.contains("visible")) {
          this.optionsBackdropTarget.classList.add("d-none")
        }
      }, 250)
    }
  }

  onBackdropClick(event) {
    if (event.target === this.optionsBackdropTarget) {
      this.closeOptionsMenu()
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  // ---------------- Pantalla Limpia (Clear Screen) ----------------

  toggleClearScreen(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    this.isClearScreen = !this.isClearScreen
    localStorage.setItem("rfbl_clear_screen", this.isClearScreen.toString())
    this.applyClearScreen(this.isClearScreen)
    this.closeOptionsMenu()
    this.showToast(this.isClearScreen ? "✨ Pantalla limpia activada" : "📱 Pantalla normal")
  }

  exitClearScreen(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    this.isClearScreen = false
    localStorage.setItem("rfbl_clear_screen", "false")
    this.applyClearScreen(false)
    this.showToast("📱 Pantalla normal activada")
  }

  applyClearScreen(active) {
    this.isClearScreen = active
    if (active) {
      document.body.classList.add("clear-screen-active")
      this.element.classList.add("clear-screen-active")
      if (this.hasExitClearScreenBtnTarget) {
        this.exitClearScreenBtnTarget.classList.remove("d-none")
      }
    } else {
      document.body.classList.remove("clear-screen-active")
      this.element.classList.remove("clear-screen-active")
      if (this.hasExitClearScreenBtnTarget) {
        this.exitClearScreenBtnTarget.classList.add("d-none")
      }
    }
    if (this.hasClearScreenSwitchTarget) {
      this.clearScreenSwitchTarget.classList.toggle("active", active)
    }
  }

  // ---------------- Desplazamiento Automático (Auto-scroll) ----------------

  toggleAutoScroll(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    this.isAutoScroll = !this.isAutoScroll
    localStorage.setItem("rfbl_auto_scroll", this.isAutoScroll.toString())
    this.applyAutoScroll(this.isAutoScroll)
    this.showToast(this.isAutoScroll ? "🔄 Auto-scroll activado" : "⏸️ Auto-scroll desactivado")
  }

  applyAutoScroll(active) {
    this.isAutoScroll = active
    if (this.hasAutoScrollSwitchTarget) {
      this.autoScrollSwitchTarget.classList.toggle("active", active)
    }
    this.videoTargets.forEach((v) => {
      v.loop = !active
      if (active) {
        v.removeAttribute("loop")
      } else {
        v.setAttribute("loop", "loop")
      }
    })
  }

  onTimeUpdate(event) {
    if (!this.isAutoScroll) return
    const video = event.currentTarget
    // Trigger when within 0.4s of video completion and video has valid duration
    if (video.duration && Number.isFinite(video.duration) && video.duration > 0.5) {
      if (video.currentTime >= video.duration - 0.4) {
        if (!video._autoScrolled) {
          video._autoScrolled = true
          this.triggerAutoScroll(video)
        }
      }
    }
  }

  onVideoEnded(event) {
    if (!this.isAutoScroll) return
    const video = event.currentTarget
    if (!video._autoScrolled) {
      video._autoScrolled = true
      this.triggerAutoScroll(video)
    }
  }

  triggerAutoScroll(video) {
    const currentCard = video.closest(".tiktok-card")
    if (!currentCard) return

    const currentIndex = this.cardTargets.indexOf(currentCard)
    let nextCard = null

    if (currentIndex !== -1 && currentIndex < this.cardTargets.length - 1) {
      nextCard = this.cardTargets[currentIndex + 1]
    } else if (this.cardTargets.length > 1) {
      // Loop back to the very first card if we reached the end of the feed
      nextCard = this.cardTargets[0]
    } else {
      // Single card feed: restart it
      video.currentTime = 0
      video._autoScrolled = false
      video.play().catch(() => {})
      return
    }

    if (!nextCard) return

    // Immediately pause the finished video to avoid background decoder interference
    video.pause()

    // Smoothly scroll viewport directly to next card using exact relative coordinates
    if (this.hasFeedViewportTarget && this.cardTargets.length > 0) {
      const baseTop = this.cardTargets[0].offsetTop || 0
      const targetTop = nextCard.offsetTop - baseTop
      this.feedViewportTarget.scrollTo({
        top: Math.max(0, targetTop),
        behavior: "smooth"
      })
    } else {
      nextCard.scrollIntoView({ behavior: "smooth", block: "start" })
    }

    // Play next video once scroll initiates
    const nextVideo = nextCard.querySelector("video")
    if (nextVideo) {
      nextVideo._autoScrolled = false
      nextVideo.currentTime = 0
      if (this.isAutoScroll) {
        nextVideo.loop = false
        nextVideo.removeAttribute("loop")
      }
      setTimeout(() => {
        this.playVideo(nextVideo)
      }, 450)
    }
  }

  // ---------------- Velocidad de Reproducción (Persistent Speed) ----------------

  selectSpeed(event) {
    event.preventDefault()
    event.stopPropagation()
    const target = event.currentTarget
    const speed = parseFloat(target.dataset.speed) || 1.0
    this.savedSpeed = speed
    localStorage.setItem("rfbl_playback_speed", speed.toString())
    this.applySpeedUI(speed)

    // Apply speed to all videos in feed
    this.videoTargets.forEach((v) => {
      v.playbackRate = speed
    })

    this.showToast(`⚡ Velocidad: ${speed}x`)
    setTimeout(() => {
      this.closeOptionsMenu()
    }, 250)
  }

  applySpeedUI(speed) {
    this.speedPillTargets.forEach((pill) => {
      const pillSpeed = parseFloat(pill.dataset.speed)
      pill.classList.toggle("active", Math.abs(pillSpeed - speed) < 0.01)
    })
  }

  updateOptionsModalUI() {
    if (this.hasClearScreenSwitchTarget) {
      this.clearScreenSwitchTarget.classList.toggle("active", this.isClearScreen)
    }
    if (this.hasAutoScrollSwitchTarget) {
      this.autoScrollSwitchTarget.classList.toggle("active", this.isAutoScroll)
    }
    this.applySpeedUI(this.savedSpeed)
  }

  // ---------------- Comments Drawer Handlers ----------------

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

  // ---------------- Upload to Feed Modal ----------------
  openUploadModal(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    if (this.hasUploadBackdropTarget) {
      this.uploadBackdropTarget.classList.remove("d-none")
      void this.uploadBackdropTarget.offsetWidth
      this.uploadBackdropTarget.classList.add("visible")
    }
  }

  closeUploadModal(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    if (this.hasUploadBackdropTarget) {
      this.uploadBackdropTarget.classList.remove("visible")
      setTimeout(() => {
        if (!this.uploadBackdropTarget.classList.contains("visible")) {
          this.uploadBackdropTarget.classList.add("d-none")
        }
      }, 250)
    }
  }

  switchSourceToLink(event) {
    if (event) event.preventDefault()
    if (this.hasSourceLinkBtnTarget) this.sourceLinkBtnTarget.classList.add("active")
    if (this.hasSourceFileBtnTarget) this.sourceFileBtnTarget.classList.remove("active")
    if (this.hasLinkSectionTarget) this.linkSectionTarget.classList.remove("d-none")
    if (this.hasFileSectionTarget) this.fileSectionTarget.classList.add("d-none")
  }

  switchSourceToFile(event) {
    if (event) event.preventDefault()
    if (this.hasSourceFileBtnTarget) this.sourceFileBtnTarget.classList.add("active")
    if (this.hasSourceLinkBtnTarget) this.sourceLinkBtnTarget.classList.remove("active")
    if (this.hasFileSectionTarget) this.fileSectionTarget.classList.remove("d-none")
    if (this.hasLinkSectionTarget) this.linkSectionTarget.classList.add("d-none")
  }

  triggerFileInput(event) {
    if (event) event.preventDefault()
    if (this.hasFileInputTarget) {
      this.fileInputTarget.click()
    }
  }

  onFileSelected(event) {
    if (this.hasFileInputTarget && this.fileInputTarget.files.length > 0) {
      const file = this.fileInputTarget.files[0]
      if (this.hasDropzoneTextTarget) {
        this.dropzoneTextTarget.textContent = `✓ Archivo seleccionado: ${file.name}`
      }
    }
  }

  onLinkInput(event) {
    const val = event.currentTarget.value.trim()
    const isYt = val.includes("youtube.com") || val.includes("youtu.be")
    if (this.hasYoutubePreviewTarget) {
      if (isYt) {
        this.youtubePreviewTarget.classList.remove("d-none")
      } else {
        this.youtubePreviewTarget.classList.add("d-none")
      }
    }
  }

  stopProp(event) {
    event.stopPropagation()
  }
}
