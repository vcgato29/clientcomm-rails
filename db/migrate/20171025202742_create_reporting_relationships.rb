class CreateReportingRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :reporting_relationships do |t|
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true
      t.references :client_status, foreign_key: true
      t.boolean :active, default: true, null: false
      t.text :notes
      t.datetime :last_contacted_at
      t.boolean :has_unread_messages, default: false, null: false
      t.boolean :has_message_error, default: false, null: false
    end
  end
end
