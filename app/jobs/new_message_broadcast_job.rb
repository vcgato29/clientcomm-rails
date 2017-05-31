class NewMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    channel = "messages_#{message.client_id}"
    content = render_message_partial(message)
    ActionCable.server.broadcast channel, message_html: content
  end

  def render_message_partial(message)
    MessagesController.render(
      partial: 'messages/message',
      locals: {message: message}
    )
  end
end