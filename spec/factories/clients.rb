FactoryGirl.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { "+1760555#{Faker::PhoneNumber.unique.subscriber_number}" }

    transient do
      associated_user { create(:user) }
    end

    after(:build) do |client, evaluator|
      client.users << evaluator.associated_user
    end
  end
end
