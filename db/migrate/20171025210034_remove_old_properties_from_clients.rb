class RemoveOldPropertiesFromClients < ActiveRecord::Migration[5.1]
  def change
    remove_column :clients, :user_id
    remove_column :clients, :client_status_id
    remove_column :clients, :active
    remove_column :clients, :notes
    remove_column :clients, :last_contacted_at
    remove_column :clients, :has_unread_messages
    remove_column :clients, :has_message_error
  end
end
