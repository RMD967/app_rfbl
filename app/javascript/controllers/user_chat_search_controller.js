import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "inboxInput", "inboxCard", "inboxEmptyFiltered"]

  connect() {
    this.debounceTimer = null
    // Load initial suggestions if results target exists
    if (this.hasResultsTarget && this.resultsTarget.children.length === 0) {
      this.fetchUsers("")
    }
  }

  // Filter existing inbox cards in real time
  filterInbox(event) {
    const query = event.target.value.toLowerCase().trim()
    let matchCount = 0

    if (this.hasInboxCardTarget) {
      this.inboxCardTargets.forEach(card => {
        const text = card.textContent.toLowerCase()
        const username = card.dataset.username ? card.dataset.username.toLowerCase() : ""
        if (!query || text.includes(query) || username.includes(query)) {
          card.style.display = ""
          matchCount++
        } else {
          card.style.display = "none"
        }
      })
    }

    if (this.hasInboxEmptyFilteredTarget) {
      if (matchCount === 0 && query.length > 0) {
        this.inboxEmptyFilteredTarget.style.display = "block"
        const querySpan = this.inboxEmptyFilteredTarget.querySelector(".search-query-text")
        if (querySpan) querySpan.textContent = query
      } else {
        this.inboxEmptyFilteredTarget.style.display = "none"
      }
    }
  }

  // Live search in modal for any user / artist by @username or name
  searchModal(event) {
    clearTimeout(this.debounceTimer)
    const query = event.target.value.trim()
    this.debounceTimer = setTimeout(() => {
      this.fetchUsers(query)
    }, 250)
  }

  async fetchUsers(query) {
    if (!this.hasResultsTarget) return

    this.resultsTarget.innerHTML = `
      <div class="text-center py-4 text-muted">
        <div class="spinner-border spinner-border-sm text-primary mb-2" role="status"></div>
        <p class="small mb-0">Buscando usuarios y artistas...</p>
      </div>
    `

    try {
      const response = await fetch(`/chatrooms/search_users?query=${encodeURIComponent(query)}`, {
        headers: { "Accept": "application/json" }
      })
      const users = await response.json()
      this.renderUsers(users, query)
    } catch (error) {
      console.error("Error searching users:", error)
      this.resultsTarget.innerHTML = `
        <div class="text-center py-4 text-danger small">
          <i class="ri-error-warning-line ri-lg mb-1 d-block"></i>
          Error al buscar usuarios. Intenta de nuevo.
        </div>
      `
    }
  }

  renderUsers(users, query) {
    if (!users || users.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="text-center py-4 text-muted">
          <i class="ri-user-unfollow-line ri-2x mb-2 d-block"></i>
          <p class="mb-1">No se encontró ningún usuario con <strong>"${query}"</strong></p>
          <span class="small text-muted">Verifica el @username o busca por su nombre.</span>
        </div>
      `
      return
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''

    const html = users.map(user => {
      const roleBadge = user.is_artist
        ? `<span class="badge-role artist"><i class="ri-music-2-fill"></i> ${user.genre || user.artist_name || 'Artista'}</span>`
        : `<span class="badge-role organizer"><i class="ri-user-smile-line"></i> Usuario</span>`

      return `
        <div class="search-user-result-item d-flex align-items-center justify-content-between p-3 rounded mb-2">
          <div class="d-flex align-items-center gap-3">
            <div class="result-user-avatar">
              <img src="${user.avatar_url}" alt="${user.name}" class="chat-avatar" style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover;">
            </div>
            <div>
              <div class="d-flex align-items-center gap-2">
                <span class="fw-bold text-white fs-6">${user.name}</span>
                ${user.is_artist ? '<i class="ri-verified-badge-fill text-primary" title="Artista verificado"></i>' : ''}
              </div>
              <div class="d-flex align-items-center gap-2 mt-1">
                <span class="text-primary small fw-semibold">@${user.username}</span>
                ${roleBadge}
              </div>
            </div>
          </div>

          <form action="/chatrooms" method="post" class="m-0">
            <input type="hidden" name="authenticity_token" value="${csrfToken}">
            <input type="hidden" name="user_id" value="${user.id}">
            <button type="submit" class="btn btn-sm btn-primary px-3 py-2 d-flex align-items-center gap-1">
              <i class="ri-chat-3-line"></i>
              <span>Chatear</span>
            </button>
          </form>
        </div>
      `
    }).join('')

    this.resultsTarget.innerHTML = `
      <div class="search-results-list">
        ${html}
      </div>
    `
  }
}
