class ReportingRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :client_status
  has_one :department, through: :user

  validates_presence_of :client
  validate :client_is_unique_within_department

  private

  def client_is_unique_within_department
    return unless user
    # SELECT
    # DISTINCT department.id
    # FROM clients
    # INNER JOIN reporting_relationships rr ON rr.client_id = client.id
    # INNER JOIN users ON users.id = rr.user_id
    # INNER JOIN departments ON departments.id = users.department_id
    # WHERE clients.id = $$
    binding.pry

    Department
      .joins(:users)
      .joins(:reporting_relationships)
      .joins(:clients)
      .where(client: {id: client.id})
  end
end
