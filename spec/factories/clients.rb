FactoryGirl.define do
  factory :client do
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }
    sequence(:phone_number) { "+1760555#{Faker::PhoneNumber.unique.subscriber_number}" }

    transient do
      associated_user create(:user)
    end

    after(:build) do |client, evaluator|
      client.users << evaluator.associated_user
    end
  end
end
