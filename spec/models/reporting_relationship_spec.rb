require 'rails_helper'

RSpec.describe ReportingRelationship, type: :model do
  describe 'validations' do
    it 'validates uniqueness of client scoped by department' do
      user = create :user

      user_in_same_department = create :user, department: user.department

      user_in_different_department = create :user

      client = create :client, user: user

      rr = create :reporting_relationship

      rr.client = client
      rr.user = user_in_same_department

      expect(rr).to_not be_valid

      rr.user = user_in_different_department

      expect(rr).to be_valid
    end
  end
end
