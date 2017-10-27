module ApplicationHelper
  def phone_number_display(phone_number)
    # format the passed phone number for display
    PhoneNumberParser.format_for_display(phone_number)
  end

  def message_inbound_or_outbound(message)
    # return a string indicating whether the message is inbound or outbound
    return Message::INBOUND if message.inbound
    Message::OUTBOUND
  end

  def client_messages_status(client, user)
    relationship = client.reporting_relationships.find_by(reporting_relationships: { user: user })
    if relationship.has_message_error
      Message::ERROR
    elsif relationship.has_unread_messages
      Message::UNREAD
    else
      Message::READ
    end
  end

  def client_timestamp(client, user)
    relationship = client.reporting_relationships.find_by(reporting_relationships: { user: user })

    (relationship.last_contacted_at || client.created_at).to_time.to_i
  end
end
