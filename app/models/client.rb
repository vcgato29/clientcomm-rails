class Client < ApplicationRecord
  has_many :reporting_relationships
  has_many :users, through: :reporting_relationships
  has_many :client_statuses, through: :reporting_relationships
  has_many :messages, -> { order(created_at: :asc) }
  has_many :attachments, through: :messages

  accepts_nested_attributes_for :reporting_relationships

  validates_with ClientValidator

  validates_presence_of :last_name, :phone_number

  def analytics_tracker_data
    {
      client_id: self.id,
      has_unread_messages: any_unread_messages?,
      hours_since_contact: hours_since_contact,
      messages_all_count: messages.count,
      messages_received_count: inbound_messages_count,
      messages_sent_count: outbound_messages_count,
      messages_attachments_count: attachments.count,
      messages_scheduled_count: scheduled_messages_count,
      has_client_notes: any_client_notes?,
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def inbound_messages_count
    # the number of messages received
    messages.inbound.count
  end

  def outbound_messages_count
    # the number of messages sent
    messages.outbound.count
  end

  def scheduled_messages_count
    messages.scheduled.count
  end

  private

  def any_unread_messages?
    self.reporting_relationships.any?(&:has_unread_messages)
  end

  def hours_since_contact
    self.reporting_relationships.min do |relationship|
      ((Time.now - (relationship.last_contacted_at || relationship.created_at)) / 3600).round
    end
  end

  def any_client_notes?
    self.reporting_relationships.any?(&:notes)
  end
end
