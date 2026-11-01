import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "prevBtn", "nextBtn", "indicator", "card"]

  connect() {
    this.updateControls = this.updateControls.bind(this)
    this.handleWheel = this.handleWheel.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)

    if (this.hasSliderTarget) {
      this.sliderTarget.addEventListener("scroll", this.updateControls, { passive: true })
      this.sliderTarget.addEventListener("wheel", this.handleWheel, { passive: false })
      window.addEventListener("keydown", this.handleKeydown)
      window.addEventListener("resize", this.updateControls)

      // Initial layout calculation
      setTimeout(() => this.updateControls(), 120)
    }
  }

  disconnect() {
    if (this.hasSliderTarget) {
      this.sliderTarget.removeEventListener("scroll", this.updateControls)
      this.sliderTarget.removeEventListener("wheel", this.handleWheel)
      window.removeEventListener("keydown", this.handleKeydown)
      window.removeEventListener("resize", this.updateControls)
    }
  }

  isMobile() {
    return window.innerWidth < 768
  }

  scrollNext(event) {
    if (event) event.preventDefault()
    if (!this.hasSliderTarget) return

    if (this.isMobile()) {
      // Mobile: swipe down / snap to next card vertically
      const cardHeight = this.sliderTarget.clientHeight || 420
      this.sliderTarget.scrollBy({ top: cardHeight, behavior: "smooth" })
    } else {
      // Tablet / Desktop: swipe entire visible row of cards horizontally
      const rowWidth = this.sliderTarget.clientWidth || 800
      this.sliderTarget.scrollBy({ left: rowWidth, behavior: "smooth" })
    }
  }

  scrollPrev(event) {
    if (event) event.preventDefault()
    if (!this.hasSliderTarget) return

    if (this.isMobile()) {
      // Mobile: snap to prev card vertically
      const cardHeight = this.sliderTarget.clientHeight || 420
      this.sliderTarget.scrollBy({ top: -cardHeight, behavior: "smooth" })
    } else {
      // Tablet / Desktop: scroll prev row horizontally
      const rowWidth = this.sliderTarget.clientWidth || 800
      this.sliderTarget.scrollBy({ left: -rowWidth, behavior: "smooth" })
    }
  }

  handleWheel(event) {
    // On tablet / desktop, translate vertical wheel scroll to smooth horizontal row scroll
    if (!this.isMobile()) {
      if (Math.abs(event.deltaY) > Math.abs(event.deltaX) && Math.abs(event.deltaY) > 8) {
        event.preventDefault()
        this.sliderTarget.scrollBy({
          left: event.deltaY * 1.6,
          behavior: "auto"
        })
      }
    }
  }

  handleKeydown(event) {
    // Only handle if active element is not an input or textarea
    if (["INPUT", "TEXTAREA"].includes(document.activeElement?.tagName)) return

    if (this.isMobile()) {
      if (event.key === "ArrowDown") {
        event.preventDefault()
        this.scrollNext()
      } else if (event.key === "ArrowUp") {
        event.preventDefault()
        this.scrollPrev()
      }
    } else {
      if (event.key === "ArrowRight") {
        event.preventDefault()
        this.scrollNext()
      } else if (event.key === "ArrowLeft") {
        event.preventDefault()
        this.scrollPrev()
      }
    }
  }

  updateControls() {
    if (!this.hasSliderTarget) return

    const slider = this.sliderTarget
    const isMob = this.isMobile()

    const scrollPos = isMob ? slider.scrollTop : slider.scrollLeft
    const maxScroll = isMob
      ? (slider.scrollHeight - slider.clientHeight)
      : (slider.scrollWidth - slider.clientWidth)

    // Update Previous / Next Buttons state
    if (this.hasPrevBtnTarget) {
      const isStart = scrollPos <= 12
      this.prevBtnTarget.disabled = isStart
      this.prevBtnTarget.classList.toggle("disabled", isStart)
    }

    if (this.hasNextBtnTarget) {
      const isEnd = scrollPos >= (maxScroll - 16)
      this.nextBtnTarget.disabled = isEnd
      this.nextBtnTarget.classList.toggle("disabled", isEnd)
    }

    // Update Counter indicator
    if (this.hasIndicatorTarget && this.hasCardTargets && this.cardTargets.length > 0) {
      const total = this.cardTargets.length
      if (isMob) {
        const cardHeight = slider.clientHeight || 420
        const currentIndex = Math.min(total, Math.max(1, Math.round(scrollPos / cardHeight) + 1))
        this.indicatorTarget.innerHTML = `<span>Evento ${currentIndex} de ${total}</span> <i class="ri-arrow-down-line ms-1 text-primary"></i>`
      } else {
        const firstCard = this.cardTargets[0]
        const cardWidth = firstCard?.offsetWidth || 300
        const gap = 20
        const stride = cardWidth + gap
        const visibleCount = Math.max(1, Math.round(slider.clientWidth / stride))
        const firstVisible = Math.min(total, Math.max(1, Math.floor((scrollPos + 10) / stride) + 1))
        const lastVisible = Math.min(total, firstVisible + visibleCount - 1)
        this.indicatorTarget.innerHTML = `<span>Eventos ${firstVisible}–${lastVisible} de ${total}</span>`
      }
    }
  }
}
