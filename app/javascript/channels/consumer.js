// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

// Reconnect ActionCable when navigating with Turbo to ensure correct user session
document.addEventListener('turbo:load', () => {
  // Disconnect and reconnect to refresh the user session
  if (consumer.connection.isOpen()) {
    consumer.connection.close()
    setTimeout(() => consumer.connection.open(), 100)
  }
})

export default consumer
