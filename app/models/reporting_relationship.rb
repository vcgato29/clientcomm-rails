class ReportingRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :client_status
end