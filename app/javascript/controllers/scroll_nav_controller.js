import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollable", "leftArrow", "rightArrow"]

  connect() {
    this.checkScroll = this.checkScroll.bind(this)

    if (this.hasScrollableTarget) {
      this.scrollableTarget.addEventListener("scroll", this.checkScroll, { passive: true })
      window.addEventListener("resize", this.checkScroll, { passive: true })

      if (window.ResizeObserver) {
        this.resizeObserver = new ResizeObserver(() => this.checkScroll())
        this.resizeObserver.observe(this.scrollableTarget)
      }

      // Initial check after DOM paint
      setTimeout(this.checkScroll, 100)
      setTimeout(() => {
        this.checkScroll()
        const activeChip = this.scrollableTarget.querySelector(".active")
        if (activeChip) {
          activeChip.scrollIntoView({ behavior: "smooth", inline: "center", block: "nearest" })
        }
      }, 200)
      setTimeout(this.checkScroll, 400)
    }
  }

  disconnect() {
    if (this.hasScrollableTarget) {
      this.scrollableTarget.removeEventListener("scroll", this.checkScroll)
      window.removeEventListener("resize", this.checkScroll)
      if (this.resizeObserver) {
        this.resizeObserver.disconnect()
      }
    }
  }

  scrollLeft(event) {
    if (event) event.preventDefault()
    if (!this.hasScrollableTarget) return
    const amount = this.getScrollAmount()
    this.scrollableTarget.scrollBy({ left: -amount, behavior: "smooth" })
  }

  scrollRight(event) {
    if (event) event.preventDefault()
    if (!this.hasScrollableTarget) return
    const amount = this.getScrollAmount()
    this.scrollableTarget.scrollBy({ left: amount, behavior: "smooth" })
  }

  getScrollAmount() {
    return Math.max(160, Math.floor(this.scrollableTarget.clientWidth * 0.65))
  }

  checkScroll() {
    if (!this.hasScrollableTarget) return
    const el = this.scrollableTarget
    const maxScroll = el.scrollWidth - el.clientWidth

    // If there is no overflow (everything fits without scrolling)
    if (maxScroll <= 4) {
      this.element.classList.remove("has-overflow")
      if (this.hasLeftArrowTarget) this.leftArrowTarget.classList.add("d-none")
      if (this.hasRightArrowTarget) this.rightArrowTarget.classList.add("d-none")
      return
    }

    this.element.classList.add("has-overflow")

    // Show/hide left arrow based on scroll position
    const canLeft = el.scrollLeft > 6
    this.element.classList.toggle("can-scroll-left", canLeft)
    if (this.hasLeftArrowTarget) {
      if (canLeft) {
        this.leftArrowTarget.classList.remove("d-none")
      } else {
        this.leftArrowTarget.classList.add("d-none")
      }
    }

    // Show/hide right arrow based on scroll position
    const canRight = el.scrollLeft < maxScroll - 6
    this.element.classList.toggle("can-scroll-right", canRight)
    if (this.hasRightArrowTarget) {
      if (canRight) {
        this.rightArrowTarget.classList.remove("d-none")
      } else {
        this.rightArrowTarget.classList.add("d-none")
      }
    }
  }
}
