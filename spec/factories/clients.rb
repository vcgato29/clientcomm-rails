FactoryGirl.define do
  factory :client do
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }
    sequence(:phone_number) { "+1760555#{Faker::PhoneNumber.unique.subscriber_number}" }

    after(:build) do |client|
      client.users << create(:user)
    end
  end
end
