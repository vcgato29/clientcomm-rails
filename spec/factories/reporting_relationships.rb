FactoryGirl.define do
  factory :reporting_relationship do
    user { nil }
    client { nil }
    client_status { ClientStatus.all.sample }
    notes { Faker::Lorem.sentence }
    active { true }
  end
end
