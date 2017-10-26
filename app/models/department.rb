class Department < ApplicationRecord
  has_many :users, through: :reporting_relationships
end