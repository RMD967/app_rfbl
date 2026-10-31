import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "item", "form"]

  connect() {
    this.closeHandler = (event) => {
      if (!this.element.contains(event.target)) {
        this.closeDropdown()
      }
    }
    document.addEventListener("click", this.closeHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.closeHandler)
  }

  onFocus() {
    this.showDropdown()
    this.filterItems()
  }

  onInput() {
    this.showDropdown()
    this.filterItems()
  }

  showDropdown() {
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.remove("d-none")
    }
  }

  closeDropdown() {
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.add("d-none")
    }
  }

  filterItems() {
    if (!this.hasInputTarget || !this.hasItemTarget) return
    const query = this.inputTarget.value.toLowerCase().trim()

    let visibleCount = 0
    this.itemTargets.forEach((item) => {
      const val = (item.dataset.searchValue || item.textContent).toLowerCase()
      if (!query || val.includes(query)) {
        item.style.display = ""
        visibleCount++
      } else {
        item.style.display = "none"
      }
    })
  }

  selectItem(event) {
    event.preventDefault()
    event.stopPropagation()
    const target = event.currentTarget
    const value = target.dataset.searchValue || target.textContent.trim()
    if (this.hasInputTarget) {
      this.inputTarget.value = value
    }
    this.closeDropdown()
    if (this.hasFormTarget) {
      this.formTarget.submit()
    }
  }
}
