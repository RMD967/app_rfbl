import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import Turbo from "@hotwired/turbo"

/* export default class extends Controller {
  static values = { chatroomId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
  }
  #insertMessageAndScrollDown(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
} */
export default class extends Controller {
  static values = { chatroomId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.messagesTarget.insertAdjacentHTML("beforeend", data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)

    // Get the form and send message button elements
    const form = document.getElementById("message-form");
    const sendButton = document.getElementById("send-message-button");

    // Add an event listener to the send message button
    sendButton.addEventListener("click", (event) => {
      event.preventDefault(); // Prevent the default form submission

      // Submit the form using Turbo Streams
      Turbo.startStream("message-form", {
        action: "submit",
        target: "messages",
      });
    });
  }
}
