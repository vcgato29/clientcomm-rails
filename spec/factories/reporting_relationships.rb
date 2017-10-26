FactoryGirl.define do
  factory :reporting_relationship do
    user { user }
    client { client }
    client_status { ClientStatus.all.sample }
    sequence(:notes) { Faker::Lorem.sentence }
    active true
  end
end
