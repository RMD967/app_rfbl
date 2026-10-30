import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatroomId: Number, currentUserId: Number }
  static targets = ["messages", "form", "input"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    this.#scrollToBottom()
  }

  #insertMessageAndScrollDown(data) {
    const isCurrentUser = this.currentUserIdValue === data.sender_id
    const tempDiv = document.createElement("div")
    tempDiv.innerHTML = data.message_html.trim()
    const messageWrapper = tempDiv.firstElementChild

    if (messageWrapper) {
      if (isCurrentUser) {
        messageWrapper.classList.remove("other-user-message")
        messageWrapper.classList.add("current-user-message")
      } else {
        messageWrapper.classList.remove("current-user-message")
        messageWrapper.classList.add("other-user-message")
      }
      this.messagesTarget.appendChild(messageWrapper)
      this.#scrollToBottom()
    }
  }

  #scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  resetForm(event) {
    if (this.hasInputTarget) {
      this.inputTarget.value = ""
    }
    if (event && event.target) {
      event.target.reset()
    }
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }
}
