FactoryGirl.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { "+1760555#{Faker::PhoneNumber.unique.subscriber_number}" }

    transient do
      active { true }
      user { create(:user) }
    end

    after(:create) do |client, evaluator|
      client.users << evaluator.user
      client.reporting_relationships.first.update(active: evaluator.active)
    end
  end
end
