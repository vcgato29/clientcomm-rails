class MigrateClientData < ActiveRecord::Migration[5.1]
  def up
    Client.all.find_each do |client|
      ReportingRelationship.create(
        user_id: client[:user_id],
        client_id: client[:id],
        client_status_id: client[:client_status_id],
        active: client[:active],
        notes: client[:notes],
        last_contacted_at: client[:last_contacted_at],
        has_unread_messages: client[:has_unread_messages],
        has_message_error: client[:has_message_error]
      )
    end
  end
end
