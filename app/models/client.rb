class Client < ApplicationRecord
  has_many :reporting_relationships
  has_many :users, through: :reporting_relationships
  has_many :client_statuses, through: :reporting_relationships
  has_many :messages, -> { order(created_at: :asc) }
  has_many :attachments, through: :messages

  before_validation :normalize_phone_number, if: :phone_number_changed?
  validate :service_accepts_phone_number, if: :phone_number_changed?

  # TODO: rewrite this validator (or comparable logic in controller) when new reporting_relationships are in place
  # validate :phone_number_is_unused, if: :phone_number_changed?

  validates :users, length: { minimum: 1 }
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

  def timestamp
    # TODO: This is for sort order on displaying client index and needs to be aware of its department
    (last_contacted_at || created_at).to_time.to_i
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

  def phone_number_is_unused
    return unless user

    client = Client.find_by_phone_number(phone_number)
    if client
      if client.user != user
        errors.add(:phone_number, :external_user_taken, user_full_name: client.user.full_name)
      else
        if client.active
          errors.add(:phone_number, :taken)
        else
          errors.add(:phone_number, :inactive_taken)
        end
      end
    end
  end

  def normalize_phone_number
    return unless self.phone_number

    self.phone_number = SMSService.instance.number_lookup(phone_number: self.phone_number)
  rescue SMSService::NumberNotFound
    @bad_number = true
  end

  def service_accepts_phone_number
    errors.add(:phone_number, :invalid) if @bad_number
  end

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
